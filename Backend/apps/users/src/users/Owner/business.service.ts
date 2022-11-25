import { PrismaService } from '@app/common';
import { HelperService } from '@app/common/helper/helper.service';
import { Injectable, Inject } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { lastValueFrom } from 'rxjs';
import { UpdateOwnerDto, BusinessOwner } from '@app/common';



@Injectable()
export class BusinessService {
    constructor(
        @Inject(PrismaService)
        private readonly prisma: PrismaService,
        @Inject('USERS')
        private readonly usersClient: ClientProxy,
        @Inject(HelperService)
        private readonly hash: HelperService,


    ) { }
    async updateExcluded(id: string, updateUserDto: UpdateOwnerDto) {
        const dates = [];
        for (let index = 0; index < updateUserDto.excluded_Days.length; index++) {
            const element = updateUserDto.excluded_Days[index];
            element.split("/")[0]
            element.split("/")[1]
            element.split("/")[2]
            dates.push(new Date(parseInt(element.split("/")[2]), parseInt(element.split("/")[0]) - 1, parseInt(element.split("/")[1])).toISOString());

        }

        console.log(dates);
        await this.prisma.owner.update(
            {
                where: {
                    id: id
                },
                data: {
                    excluded_Days: dates
                }

            }
        )
    }
    async findByUserId(id: string) {
        const Owner = await this.prisma.owner.findUnique(
            {
                where: {
                    userId: id
                }, include: {
                    user: true,
                    estimate_preferences: true

                }
            }
        );


        return Owner;
    }



    async create(createUserDto: BusinessOwner) {

        createUserDto.user.verify_key = this.hash.makeid(8);
        const { address, ...user } = createUserDto.user;
        user.password = await this.hash.hashPassword(user.password, 10);

        const newUser = await this.prisma.owner.create({
            data: {
                user: {
                    create: {
                        ...user,
                        address: {
                            create: {
                                ...address
                            }
                        }
                    }
                },

            },
            include: {
                user: true
            }
        })

        await lastValueFrom(
            this.usersClient.emit('create', { "id": newUser.user.id, "verify_key": newUser.user.verify_key, "email": newUser.user.email, "name": newUser.user.name })
        )

        return newUser;
    }


    async findAll() {

        return await this.prisma.owner.findMany();
    }

    async findOne(id: string) {
        const userInfo = await this.prisma.owner.findUnique(
            {
                where: {
                    id: id
                }
            }
        )
        return userInfo;
    }

    async updatePref(id: string, updateUserDto: UpdateOwnerDto) {
        const { estimatePreferences } = updateUserDto;

        await this.prisma.estimateDayPreference.deleteMany({
            where: {
                ownerId: id
            }
        })
        let preferences = this.makeDaySlots(estimatePreferences, id);

        await this.prisma.estimateDayPreference.createMany({

            data: preferences
        });



    }

    async remove(id: string) {
        return await this.prisma.owner.delete({ where: { id: id } });
    }


    makeDaySlots(estimatePreferences, id) {
        let timeSlots = [];
        let preferences = [];
        var start: number;
        var end: number;
        var element;
        for (let index = 0; index < estimatePreferences.length; index++) {
            timeSlots = [];
            element = estimatePreferences[index];
            console.log(element);
            start = parseInt(element.from.at(0));
            end = parseInt(element.to.at(0));
            if (element.from.endsWith("AM")) {
                //8am-12pm
                if (element.to.endsWith("PM")) {
                    //go until 12pm 
                    while (start != 12) {
                        timeSlots.push(`${start}:00 AM`)
                        start++;
                       
                    }
                    
                } else {
                    while (start < end) {
                        timeSlots.push(`${start}:00 AM`)
                        start++;
                       
                    }
                }
                
            }
            console.log(start);
            if (start == 12 || start==1) {
                console.log("inside",start);
                start = 1;
                while (start < end) {

                    timeSlots.push(`${start}:00 PM`)
                    start++;
                }
            }
            preferences.push({ day: element.day, timeSlots: timeSlots, ownerId: id });




        }
        console.log(preferences);
        return preferences;
    }



}
