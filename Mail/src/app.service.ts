
import { Inject, Injectable, Logger } from '@nestjs/common';

import { MailService } from 'libs/common';

@Injectable()
export class AppService {
  constructor(
    @Inject(MailService)
    private readonly email: MailService
  ) { }
  async createUser(data: any) {
    console.log("hello",data);
    await this.email.sendUserConfirmationEmail(data.id, data.email, data.verify_key,data.name)

  }
  getHello(): string {
    return 'Hello World!';
  }
}
