import { MailerService } from "@nestjs-modules/mailer";
import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";


@Injectable()
export class MailService {
  constructor(
    @Inject(ConfigService)
    private readonly config: ConfigService,
    @Inject(MailerService)
    private readonly mail: MailerService
  ) { }

  async sendUserConfirmationEmail(id: string, email: string, token: string,name:string) {
    
    const url = `https://businessautomation.w3spaces.com/emailconfirmation.html?id=${id}&verify_key=${token}`;
    await this.mail.sendMail({
      to: email,
      subject: 'Welcome to Business Automation, Confirm your email',
      html: `
      <p style="font-size:5vw">Welcome ${name}!</p>
      <p>Please click the link below to confirm your email</p>
      <p>
        <a href='${url}'>Confirm</a>
      </p>
      <p>If you did not request this email you can safely ignore it.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }
}