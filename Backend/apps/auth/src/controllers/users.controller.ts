import { CreateUserDto, UpdateUserDto } from '@app/common';
import { Body, Controller, Delete, Get, Param, Patch, Post } from '@nestjs/common';
import { Public } from '../decorators/public.decorator';
import { GetUserId } from '../decorators/user-id.decorator';
import { UsersService } from '../services/users.service';

@Controller('users')
export class UsersController {
  constructor(
    private readonly usersSerivce: UsersService
  ) { }


  @Patch('owner/update/preferences/:id')
  async updatePref(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return await this.usersSerivce.updateOwnerPref(id, updateUserDto);
  }
  @Get('usertype/:email')
  async userType(@Param('email') email: string) {
    return await this.usersSerivce.userType(email);
  }
}