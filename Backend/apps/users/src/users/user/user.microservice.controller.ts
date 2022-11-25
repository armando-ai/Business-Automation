import { UpdateUserDto } from '@app/common';
import { Controller } from '@nestjs/common';
import { MessagePattern, Payload } from '@nestjs/microservices';
import { BusinessService } from '../Owner/business.service';
import { UsersService } from './users.service';

@Controller()
export class UserMicroServiceController {
  constructor(private readonly usersService: UsersService,private readonly ownerService:BusinessService) { }

  @MessagePattern('validate credentials')
  async validateCredentials(@Payload('username') username: string) {
    console.log('I am in the validate credentials function');
    return await this.usersService.loginCredentials(username);
  }

  @MessagePattern('update token')
  async updateToken(
    @Payload('id')
    id: string,
    @Payload('refresh_token')
    rt: string
  ) { 
    console.log(`data payload: ${id} \n${rt}`);
    return await this.usersService.updateToken(id, rt);
  }
  

}