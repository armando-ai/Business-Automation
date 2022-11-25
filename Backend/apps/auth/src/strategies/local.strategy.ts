import { Inject, Injectable, UnauthorizedException } from "@nestjs/common";
import { PassportStrategy } from "@nestjs/passport";
import { Strategy } from "passport-local";
import { AuthService } from "../services/auth.service";

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(
    @Inject(AuthService)
    private readonly authService: AuthService
  ) { super(); }

  async validate(username: string, password: string) {
    const user = await this.authService.validate(username, password);
    if(!user)
      throw new UnauthorizedException('invalid username or password');
    return user;
  }
}