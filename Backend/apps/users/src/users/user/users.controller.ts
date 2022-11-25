import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { UsersService } from './users.service';


import { CreateUserDto, UpdateUserDto } from '@app/common';
import { Public } from 'apps/auth/src/decorators/public.decorator';

@Controller('user')
export class UsersController {
  constructor(private readonly usersService: UsersService
    ) { }

  @Public()
  @Post('register')
  async create(@Body('user') createUserDto: CreateUserDto) {
    return await this.usersService.create(createUserDto);
  }
  
  @Get()
  async findAll() {
    return await this.usersService.findAll();
  }
  
  @Get(':id')
  async findOne(@Param('id') id: string) {
    return await this.usersService.findOne(id);
  }
  
  @Patch(':id')
  async update(@Param('id') id: string, @Body('user') updateUserDto: UpdateUserDto) {
    return await this.usersService.update(id, updateUserDto);
  }

  @Public()
  @Get('verify_key/:id')
  async verifyKey(@Param('id') id: string) {
    return await this.usersService.verifyFind(id);
  }

  @Public()
  @Patch('email/:id')
  async verify(@Param('id') id: string, @Body('user') updateUserDto: UpdateUserDto) {

    return await this.usersService.update(id, updateUserDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    return await this.usersService.remove(id);
  }

  @Get('usertype/:email')
  async userType(@Param('email') email: string) {
    return await this.usersService.userType(email);
  }

}
