import { HelperService, USERS_SERVICE } from '@app/common';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { ClientProxy } from '@nestjs/microservices';
import { lastValueFrom } from 'rxjs';

@Injectable()
export class AuthService {
  constructor(
    @Inject(ConfigService)
    private readonly config: ConfigService,
    @Inject(USERS_SERVICE)
    private readonly usersClient: ClientProxy,
    @Inject(JwtService)
    private readonly jwt: JwtService,
    @Inject(HelperService)
    private readonly helperService: HelperService
  ) { }

  async login(id: string) {
    const tokens = await this.generateTokens(id);
    await lastValueFrom(this.usersClient.send('update token', { id: id, refresh_token: tokens.refresh_token }));
    return tokens;
  }

  async updateToken(id: string, rt: string) {
    if(await lastValueFrom(this.usersClient.send('get token', { id: id, refresh_token: rt }))) {
      const tokens = await this.generateTokens(id);
      await lastValueFrom(this.usersClient.send('refresh token', { id: id, refresh_token: tokens.refresh_token }));
      return tokens;
    }
  }

  async validate(username: string, password: string) {
    const user: { id: string, password: string } = await lastValueFrom(this.usersClient.send('validate credentials', { username: username }));
    if (user && await this.helperService.compare(password, user.password)) {
      const { password, id } = user;
      return id;
    }
    return null;
  }
  
  async logout(id: string) {
    this.usersClient.send('log out', { id: id });
  }

  private async generateTokens(id: string) {
    const payload = { sub: id };
    const tokens = await Promise.all([
      this.jwt.sign(
        payload, {
        secret: this.config.get<string>('access_token'),
        expiresIn: 60 * 15
      }),
      this.jwt.sign(
        payload, {
          secret: this.config.get<string>('refresh_token'),
          expiresIn: 60 * 60 * 24 * 7
        }
      )
    ]);
    return {
      access_token: tokens[0],
      refresh_token: tokens[1]
    };
  }
}
