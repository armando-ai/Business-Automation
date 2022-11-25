import { CreateUserDto, UpdateOwnerDto, UpdateUserDto, USERS_SERVICE } from "@app/common";
import { Inject, Injectable } from "@nestjs/common";
import { ClientProxy } from "@nestjs/microservices/client";
import { lastValueFrom } from 'rxjs';

@Injectable()
export class UsersService {
  
 
  constructor(
    @Inject(USERS_SERVICE)
    private readonly client: ClientProxy
  ) { }
  async updateOwnerPref(id: string, updateOwnerDto: UpdateOwnerDto) {
    return await lastValueFrom(this.client.send('owner pref', { id:id,owner:updateOwnerDto}));
  }
  async userType(email: string) {
    return await lastValueFrom(this.client.send('user type', { email: email}));
  }
  async registerUser(user: CreateUserDto) {
    return await lastValueFrom(this.client.send('register user', { user: user }));
  }

  async findAllUsers() {
    return await lastValueFrom(this.client.send('find all users', { }));
  }

  async findUserById(id: string) {
    return await lastValueFrom(this.client.send('find user by id', { id: id }));
  }

  async updateUser(id: string, user: UpdateUserDto) {
    return await lastValueFrom(this.client.send('update user', { id: id, user: user }));
  }

  async removeUser(id: string) {
    return await lastValueFrom(this.client.send('remove user', { id: id }));
  }
}