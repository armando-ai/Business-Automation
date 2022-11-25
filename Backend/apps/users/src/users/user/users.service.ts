import { PrismaService } from '@app/common';

import { HelperService } from '@app/common/helper/helper.service';
import { Injectable, Inject } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { lastValueFrom } from 'rxjs';
import { CreateUserDto, UpdateUserDto } from '@app/common';

@Injectable()
export class UsersService {

  constructor(
    @Inject(PrismaService)
    private readonly prisma: PrismaService,
    @Inject('USERS')
    private readonly usersClient: ClientProxy,
    @Inject(HelperService)
    private readonly helperService: HelperService,

  ) { }

  async verifyFind(id: string) {
    const userInfo = await this.prisma.user.findUnique(
      {
        where: {
          id: id
        },
        select: {
          verify_key: true
        }
      }
    )
    return userInfo;
  }
  async create(createUserDto: CreateUserDto) {

    createUserDto.verify_key = this.helperService.makeid(8);
    const { address, ...user } = createUserDto;
    user.name= this.helperService.capitolizeLetter(user.name); 
    user.password = await this.helperService.hashPassword(user.password, 10);
    const newUser = await this.prisma.user.create({
      data: {
        ...user,
        address: {
          create: {
            ...address
          }
        }
      }
    });
    await lastValueFrom(
      this.usersClient.emit('create', { id: newUser.id, verify_key: newUser.verify_key, email: newUser.email, name: newUser.name })
    )
     const client = await this.prisma.client.create({
        data:{
          userId:newUser.id
        },include:{
          user:true
        }
      })
    return client;
  }


  async findAll() {

    return await this.prisma.user.findMany();
  }

  async findOne(id: string) {
    const userInfo = await this.prisma.user.findUnique(
      {
        where: {
          id: id
        }
      }
    )
    return userInfo;
  }

  async update(id: string, updateUserDto: UpdateUserDto) {
    const { address, ...user } = updateUserDto;
     const rawUser = await this.prisma.client.findFirst({
      where:{
        id:id
      }
     })
    const val = await this.prisma.user.update({
      where: { id: rawUser.userId},
      data: {
        ...user,
        address: {
          update: {
            ...address
          }
        }
      }
    });
    return val;

  }

  async remove(id: string) {
    return await this.prisma.user.delete({ where: { id: id } });
  }

  async loginCredentials(email: string) {
    return await this.prisma.user.findUnique({
      where: {
        email: email
      },
      select: {
        id: true,
        role: true,
        password: true,
        verified: true
      }
    });
  }
  
  public async userType(email: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        email: email
       
      },
      select: {
        id: true,
        role: true,
        verified: true
      }
    })
    if (user.verified == false) {
      return { user: "Unverified User" }
    } else {
      switch (user.role) {
        case ("owner"):
          const Owner = await this.prisma.owner.findUnique(
            {
              where: {
                userId: user.id
              }, include: {
                user: true,
                estimate_preferences: true
              }
            });
          if (Owner.estimate_preferences.length == 0) {
            return { user: "newOwner", id: Owner.id }
          } else {
            return { user: "Owner", id: Owner.id }
          }
          
        case ("guest"):
          const Guest = await this.prisma.client.findUnique(
            {
              where: {
                userId: user.id
              }, include: {
                user: true,
                appointment_slots:true
              }
            });
          if (Guest.appointment_slots.length==0) {
            return { user: "newGuest", id: Guest.id }
          } else {
            return { user: "Guest", id: Guest.id }
          }
          case ("Client"):
            const Client = await this.prisma.client.findUnique(
              {
                where: {
                  userId: user.id
                }, include: {
                  user: true,
                  appointment_slots:true
                }
              });
              return { user: "Client", id: Client.id }
        default:
          return "guest";
      }
    }
  }

  async updateToken(id: string, rt: string) {
    console.log(id);
    return await this.prisma.user.update({
      where: { id: id },
      data: {
        refresh_token: await this.helperService.hashPassword(rt, 10)
      }
    });
  }


}
