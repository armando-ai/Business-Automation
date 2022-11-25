
import { Inject, Injectable, Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Cron, CronExpression } from '@nestjs/schedule';

import { lastValueFrom } from 'rxjs';
import { appointment_slots, CreateCalendarDayDto, quote } from './dto/createDay.dto';
import { PrismaService } from '@app/common';
import { Quote } from '@prisma/client';
import { json } from 'stream/consumers';
import { raw } from '@prisma/client/runtime';
import { UpdateQuote } from './dto/updateDay.dto';
import { ConsoleLogger } from '@nestjs/common/services';
import { userInfo } from 'os';


@Injectable()
export class CalendarService {
  async deleteClient(id: any) {
    const userAppts = await this.prisma.appointment_slots.findMany({
      where: {
        clientId: id
      }, include: {
        client: true,
        CalendarDay: true
      }
    })
    for (let index = 0; index < userAppts.length; index++) {
      const appt = userAppts[index];
      if (appt.type == "client_appointment") {
        await this.prisma.appointment_slots.delete({
          where: {
            id: appt.id
          }
        })
        //update slots
        const calendarDay = await this.prisma.calendarDay.findFirst({
          where: {
            id: appt.CalendarDay.id
          }
        })
        calendarDay.slots_available.push(appt.time);
        const rawCalendarDay = await this.prisma.calendarDay.update({
          where: {
            id: calendarDay.id
          },
          data: {
            slots_available: calendarDay.slots_available.sort(function (a, b) {
              return new Date('1970/01/01 ' + a).valueOf() - new Date('1970/01/01 ' + b).valueOf();
            })
          }
        })
      }
    }

    const userinfo = await this.prisma.user.findFirst({
      where: {
        client: { id: id }
      }, include: {
        client: true,
        address: true
      }
    })
    const address = await this.prisma.address.findFirst({
      where: {
        id: userinfo.addressId
      }
    })
    let addy;
    if (address.suite) {
      addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

    } else {
      addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

    }
    const ownerinfo = await this.prisma.owner.findMany(
      {
        include: {
          user: true
        }
      }
    );
  const quote=    await this.prisma.quote.findFirst({
      where:{
        clientId:id
      }
    })
    await this.prisma.quote.update({
      where:{
        id:quote.id
      },data:{
        state:"Owner Responded"
      }
    })
    await this.calendarClient.emit("service termination1", { name: userinfo.name, email: userinfo.email });

    await this.calendarClient.emit("service termination2", { name: userinfo.name, address: addy, email: ownerinfo.at(0).user.email });


  }
  async getAllClients() {
    const clients = [];
    const allClients = await this.prisma.client.findMany({
      include: {
        user: true
      },
      orderBy: {
        user: {
          name: 'asc',
        },
      }
    })
    for (let index = 0; index < allClients.length; index++) {
      const user = allClients[index].user;
      const amtDue = allClients[index].amt_due;
      const amtOwed = allClients[index].amt_owed;
      const address = await this.prisma.address.findFirst({
        where: {
          id: user.addressId
        }
      })
      let addy;
      if (address.suite) {
        addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

      } else {
        addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

      }

      clients.push({
        name: user.name, address: addy, email: user.email, balance: amtOwed, due: amtDue
      })


    }
    return clients;
    //go through all clients 
  }

  async getExcluded() {
    const owner = await this.prisma.owner.findMany({
    })

    return owner.at(0).excluded_Days;
  }


  constructor(
    @Inject('CALENDAR')
    private readonly calendarClient: ClientProxy,
    @Inject(PrismaService)
    private readonly prisma: PrismaService
  ) { }
  async ownerAcepptQuote(id: any, updateQuote: UpdateQuote) {
    id = parseInt(id);
    //if a counter offer is provided
    //update quote and send emit to both client and owner
    const ownerinfo = await this.prisma.owner.findMany(
      {
        include: {
          user: true
        }
      }
    );


    const quote = await this.prisma.quote.update({
      where: {
        id: id
      }, data: {
        state: updateQuote.state
      }
    })
    const { user } = await this.prisma.client.findFirst({
      where: {
        id: quote.clientId
      }, include: {
        user: true,
      }
    })
    const address = await this.prisma.address.findFirst({
      where: {
        id: user.addressId
      }
    })
    let addy;
    if (address.suite) {
      addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;
    } else {
      addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

    }
    //send email to owner and to client 
    await lastValueFrom(
      this.calendarClient.emit('accepted client offer', { "email": ownerinfo.at(0).user.email, "name": user.name, location: addy, "quote": quote })
    )
    await lastValueFrom(
      this.calendarClient.emit('accepted client copy', { "email": user.email, "name": user.name, "quote": quote })
    )
    return 'Success';

  }
  private readonly logger = new Logger(CalendarService.name);

  async pendingEstimates() {
    //get those users that are not clients
    const users = await this.prisma.user.findMany({
      where: {
        role: 'guest' || 'client'
      }
    });
    const pendingClients = []
    for (let index = 0; index < users.length; index++) {
      const element = users[index];

      const client = await this.prisma.client.findFirst({
        where: {
          userId: element.id,
        }, include: {
          quote: true,
          appointment_slots: true
        }
      })
      const address = await this.prisma.address.findFirst({
        where: {
          id: element.addressId
        }
      })
      let addy;
      if (address.suite) {
        addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

      } else {
        addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

      }
      //if no quote and has no 

      if (client.quote.length == 0 && client.appointment_slots.length > 0) {
        //show as pending quote for owner to send 
        pendingClients.push({ name: element.name, location: addy, state: 'needs quote', clientId: client.id });


      } else if (client.quote.length > 0) {
        //if there is a quote check the state only bring back those not responded by declined
        for (let index = 0; index < client.quote.length; index++) {
          const quote = client.quote[index];



          if (quote.state == 'ownerDecline' || quote.state == 'clientDecline' || quote.state == 'accepted') {

          } else {
            pendingClients.push({ name: element.name, location: addy, state: quote.state, clientId: client.id, quote: quote })
          }
        }



      }

    }

    return await pendingClients;
  };

  async getQuoteClient(id) {
    const quotes = await this.prisma.quote.findMany({
      where: {
        clientId: id
      }
    })
    const rawQuotes = [];
    const appts = await this.prisma.appointment_slots.findMany({
      where: {
        clientId: id,
        type: 'client_estimate'
      }
    })
    for (let index = 0; index < quotes.length; index++) {
      const element = quotes[index];
      const appt = appts[index];

      if (element.state == 'completed') {

      } else {
        rawQuotes.push({ date: appt.date, state: element.state, clientId: id, quote: element })
      }
    }
    return rawQuotes;
  }
  async getAppointments(id: any) {
    let day = new Date();
    // :white_check_mark: Exclude start date
    const userAppts = await this.prisma.appointment_slots.findMany({
      where: {
        clientId: id,
        date: {
          gte: new Date(day.getFullYear(), day.getMonth(), day.getDate())
        }
      }, orderBy: {
        date: 'desc'
      },
    });

    return userAppts;
  }

  @Cron(CronExpression.EVERY_DAY_AT_5PM)
  async handleNextDayReminder() {
    const day = new Date();
    const calendarDay = await this.prisma.calendarDay.findFirst({
      where: {
        date: new Date(day.getFullYear(), day.getMonth(), day.getDate() + 1)
      }, include: {
        appointment_slots: true
      }
    });
    if (calendarDay.appointment_slots.length > 0) {
      const ownerAppts = [];
      for (let index = 0; index < calendarDay.appointment_slots.length; index++) {
        const appt = calendarDay.appointment_slots.at(index);
        const { user } = await this.prisma.client.findFirst({
          where: {
            id: appt.clientId
          }, include: {
            user: true
          }
        });

        ownerAppts.push({ name: user.name, type: appt.type, time: appt.time })

        await lastValueFrom(
          this.calendarClient.emit('remind appt', { "email": user.email, "name": user.name, "appt": appt })
        )
      }
      const ownerinfo = await this.prisma.owner.findMany(
        {
          include: {
            user: true
          }
        }
      );
      await lastValueFrom(
        this.calendarClient.emit('remind owner', { "email": ownerinfo.at(0).user.email, "name": ownerinfo.at(0).user.name, "appts": ownerAppts })
      )
    }
  }

  async dailySchedule() {
    const day = new Date();
    const calendarDay = await this.prisma.calendarDay.findFirst({
      where: {
        date: new Date(day.getFullYear(), day.getMonth(), day.getDate())
      }, include: {
        appointment_slots: true
      }
    });

    const ownerAppts = [];
    if (calendarDay) {

      for (let index = 0; index < calendarDay.appointment_slots.length; index++) {
        const appt = calendarDay.appointment_slots.at(index);
        const { user } = await this.prisma.client.findFirst({
          where: {
            id: appt.clientId
          }, include: {
            user: true
          }
        });
        const address = await this.prisma.address.findFirst({
          where: {
            id: user.addressId
          }
        })
        if (address.suite) {
          const addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;
          ownerAppts.push({ name: user.name, type: appt.type, time: appt.time, address: addy })
        } else {
          const addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;
          ownerAppts.push({ name: user.name, type: appt.type, time: appt.time, address: addy })

        }
      }
    }


    return ownerAppts;


  }

  async getDatesInRange(startDate: Date, endDate: Date) {
    var estimateSlots = await this.getOwnerPreferences();
    startDate = new Date(startDate);
    const start = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + 1);
    // :white_check_mark: Exclude start date
    endDate = new Date(endDate);
    const end = new Date(endDate.getFullYear(), endDate.getMonth(), endDate.getDate());
    var dates = [];

    while (start < end) {

      if (estimateSlots.find(value => value.day == start.getDay())) {
        const index = estimateSlots.findIndex((emp) => emp.day == start.getDay());

        dates.push({ date: new Date(start), time_slots: estimateSlots.at(index)['time_slots'] });


      }

      start.setDate(start.getDate() + 1);

    }

    const user = await this.prisma.owner.findMany();
    const excluded = user.at(0).excluded_Days;

    for (let i = 0; i < excluded.length; i++) {
      const element = new Date(excluded[i]);

      const index = dates.findIndex((emp) => emp.date + '' == new Date(element.getFullYear(), element.getMonth(), element.getDate() + 1) + '');

      if (index != -1) {
        dates.splice(index, 1);
      }

    }


    const existingDates = await this.prisma.calendarDay.findMany({
      where: {
        date: {
          gte: new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + 1),
          lte: end
        },

      }
    });

    for (let index = 0; index < existingDates.length; index++) {
      const element = existingDates.at(index);

      const index1 = dates.findIndex((emp) => emp.date + '' == element.date + '');

      if (index1 != -1) {
        var date = { date: dates.at(index1).date, time_slots: element.slots_available }

        dates.splice(index1, 1, date);

      }


    }


    return await dates;
  }

  async createEstimate(calendarDay: CreateCalendarDayDto) {


    const estimate = await this.prisma.calendarDay.findFirst({
      where: {
        date: new Date(calendarDay.date)
      }, include: {
        appointment_slots: true,

      }
    });
    //date has slots taken up
    if (estimate) {
      //update with new slots available
      await this.prisma.calendarDay.update({
        where: { id: estimate.id },
        data: {
          slots_available: calendarDay.daySlotsAvailable
        }
      });

      //add new point meant slot to calendar day 

      let appt = await this.prisma.appointment_slots.create({
        data: {
          date: estimate.date,
          time: calendarDay.appointment_slots.at(0).time,
          type: calendarDay.appointment_slots.at(0).type,
          clientId: calendarDay.appointment_slots.at(0).clientId,
          calendarDayId: estimate.id
        }, include: {
          client: true,

        }
      })
      const userinfo = await this.prisma.user.findFirst({
        where: {
          id: appt.client.userId
        }
      })
      //send email to let user know about confirmed estimate 
      //allow for cancellation through a link by providing delete on it 
      await lastValueFrom(
        this.calendarClient.emit('confirm estimate', { "id": appt.clientId, "email": userinfo.email, "name": userinfo.name, "appt": appt })
      )
      const ownerinfo = await this.prisma.owner.findMany(
        {
          include: {
            user: true
          }
        }
      );

      await lastValueFrom(
        this.calendarClient.emit('owner estimate', { "email": ownerinfo.at(0).user.email, "name": userinfo.name, "appt": appt })
      )
    } else {
      //add calendar day as it was not found
      const createEstimate = await this.prisma.calendarDay.create({
        data: {
          date: new Date(calendarDay.date),
          slots_available: calendarDay.daySlotsAvailable,
        }
      })
      // add appointment meant to calendar day 
      const appt = await this.prisma.appointment_slots.create(
        {
          data: {
            date: new Date(createEstimate.date),
            time: calendarDay.appointment_slots.at(0).time,
            type: calendarDay.appointment_slots.at(0).type,
            clientId: calendarDay.appointment_slots.at(0).clientId,
            calendarDayId: createEstimate.id
          },
          include: {
            client: true,

          }

        }
      )
      const userinfo = await this.prisma.user.findFirst({
        where: {
          id: appt.client.userId
        }
      })
      //send email to let user know about confirmed estimate 
      //allow for cancellation through a link by providing delete on it 
      await lastValueFrom(
        this.calendarClient.emit('confirm estimate', { "id": appt.clientId, "email": userinfo.email, "name": userinfo.name, "appt": appt })
      )

      const ownerinfo = await this.prisma.owner.findMany(
        {
          include: {
            user: true
          }
        }
      );

      await lastValueFrom(
        this.calendarClient.emit('owner estimate', { "email": ownerinfo.at(0).user.email, "name": userinfo.name, "appt": appt })
      )


    }
  }

  async createQuote(quote: Quote) {

    const rawQuote = await this.prisma.quote.create({
      data: {
        biweekly: quote.biweekly,
        weekly: quote.weekly,
        initial: quote.initial,
        monthly: quote.monthly,
        clientId: quote.clientId,
        triweekly: quote.triweekly,
        state: quote.state
      }
    })
    const ownerinfo = await this.prisma.owner.findMany(
      {
        include: {
          user: true
        }
      }
    );
    const { user } = await this.prisma.client.findFirst({
      where: {
        id: quote.clientId
      }, include: {
        user: true,
      }
    })
    const address = await this.prisma.address.findFirst({
      where: {
        id: user.addressId
      }
    })
    let addy;
    if (address.suite) {
      addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

    } else {
      addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

    }
    await lastValueFrom(
      this.calendarClient.emit('owner quote', { "email": ownerinfo.at(0).user.email, "name": user.name, location: addy, "quote": rawQuote })
    )
    await lastValueFrom(
      this.calendarClient.emit('client quote', { "email": user.email, "name": user.name, "quote": rawQuote })
    )


  }

  async removeExcludedDates(dates) {

    return dates;

  }

  async deleteAppointmentSlot(id, type: String) {
    //get appt
    console.log(id, type);
    const appt = await this.prisma.appointment_slots.findFirst({
      where: {
        id: id
      }, include: {
        client: true,
        CalendarDay: true
      }
    })
    await this.prisma.appointment_slots.delete({
      where: {
        id: id
      }
    })
    //update slots
    const calendarDay = await this.prisma.calendarDay.findFirst({
      where: {
        id: appt.CalendarDay.id
      }
    })
    calendarDay.slots_available.push(appt.time);
    const rawCalendarDay = await this.prisma.calendarDay.update({
      where: {
        id: calendarDay.id
      }
      ,
      data: {
        slots_available: calendarDay.slots_available.sort(function (a, b) {
          return new Date('1970/01/01 ' + a).valueOf() - new Date('1970/01/01 ' + b).valueOf();
        })
      }, include: {
        appointment_slots: true
      }
    })
    //send email to cancelling user

    const user = await this.prisma.user.findFirst({
      where: {
        client: appt.client
      }
    });
    //send email to owner of new schedule and canellation
    const ownerinfo = await this.prisma.owner.findMany(
      {
        include: {
          user: true
        }
      }
    );
    const end = new Date(appt.date);
    end.setDate(end.getDate() + 9);
    const availableDates = await this.getDatesInRange(appt.date, end)
    //allow for cancellation through a link by providing delete on it 

    if (type.trim().valueOf() == 'owner') {
      await lastValueFrom(
        this.calendarClient.emit('owner cancelled', { "email": user.email, "name": user.name, "appt": appt, "available": availableDates })
      )
      await lastValueFrom(
        this.calendarClient.emit('owner cancelled copy', { "email": ownerinfo.at(0).user.email, "name": user.name, "appt": appt, "appts": rawCalendarDay.appointment_slots })
      )
    }
    else {
      await lastValueFrom(
        this.calendarClient.emit('cancel estimate', { "email": user.email, "name": user.name, "appt": appt })
      )

      await lastValueFrom(
        this.calendarClient.emit('cancel owner estimate', { "email": ownerinfo.at(0).user.email, "client_name": user.name, "appt": appt, "appts": rawCalendarDay.appointment_slots })
      )


    }





    return { appt: appt, name: user.name }
  }

  async getOwnerPreferences() {
    const estimateSlots = [];
    const user = await this.prisma.owner.findMany();
    var dayPrefs = await this.prisma.estimateDayPreference.findMany({
      where: {
        ownerId: user.at(0).id
      },
    });
    for (let index = 0; index < dayPrefs.length; index++) {
      const element = dayPrefs[index];

      switch (element.day.toString()) {
        case "Monday": {
          estimateSlots.push({ day: 1, time_slots: element.timeSlots });
          break;
        };
        case "Tuesday": {
          estimateSlots.push({ day: 2, time_slots: element.timeSlots });
          break;
        };
        case "Wednesday": {
          estimateSlots.push({ day: 3, time_slots: element.timeSlots });
          break;
        };
        case "Thursday": {
          estimateSlots.push({ day: 4, time_slots: element.timeSlots });
          break;
        };
        case "Friday": {
          estimateSlots.push({ day: 5, time_slots: element.timeSlots });
          break;
        };
        case ("Saturday"): {
          estimateSlots.push({ day: 6, time_slots: element.timeSlots });
          break;
        };
        case ("Sunday"): {
          estimateSlots.push({ day: 0, time_slots: element.timeSlots });
          break;
        };
        default: {
          break;
        }

      }

    }
    return estimateSlots;
  }

  async updateQuote(id, updateQuote: UpdateQuote) {
    id = parseInt(id);
    //if a counter offer is provided
    //update quote and send emit to both client and owner
    const ownerinfo = await this.prisma.owner.findMany(
      {
        include: {
          user: true
        }
      }
    );

    if (updateQuote.offerClient) {
      const quote = await this.prisma.quote.update({
        where: {
          id: id
        }, data: {
          offerType: updateQuote.offerType,
          offerClient: updateQuote.offerClient,
          state: updateQuote.state,
        }
      })
      const { user } = await this.prisma.client.findFirst({
        where: {
          id: quote.clientId
        }, include: {
          user: true,
        }
      })
      const address = await this.prisma.address.findFirst({
        where: {
          id: user.addressId
        }
      })
      let addy;
      if (address.suite) {
        addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

      } else {
        addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

      }
      //send email to owner and to client 
      await lastValueFrom(
        this.calendarClient.emit('client offer', { "email": ownerinfo.at(0).user.email, "name": user.name, location: addy, "quote": quote })
      )
      await lastValueFrom(
        this.calendarClient.emit('client to owner quote', { "email": user.email, "name": user.name, "quote": quote })
      )

      //if client accept let owner know update quote 
    } else if (updateQuote.offerOwner) {


      const quote = await this.prisma.quote.update({
        where: {
          id: id
        }, data: {
          offerType: updateQuote.offerType,
          offerOwner: updateQuote.offerOwner,
          state: updateQuote.state,
        }
      })
      //send email to owner and to client 
      const { user } = await this.prisma.client.findFirst({
        where: {
          id: quote.clientId
        }, include: {
          user: true,
        }
      })
      const address = await this.prisma.address.findFirst({
        where: {
          id: user.addressId
        }
      })
      let addy;
      if (address.suite) {
        addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

      } else {
        addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

      }
      //send email to owner and to client 
      await lastValueFrom(
        this.calendarClient.emit('owner offer', { "email": ownerinfo.at(0).user.email, "name": user.name, location: addy, "quote": quote })
      )
      await lastValueFrom(
        this.calendarClient.emit('owner to client quote offer', { "email": user.email, "name": user.name, "quote": quote })
      )
      //if client accept let owner know update quote 

    } else if (updateQuote.state) {

      const quote = await this.prisma.quote.update({
        where: {
          id: id
        }, data: {
          state: updateQuote.state,
        }
      })

      //send email to owner and to client 
      const { user } = await this.prisma.client.findFirst({
        where: {
          id: quote.clientId
        }, include: {
          user: true,
        }
      })
      const address = await this.prisma.address.findFirst({
        where: {
          id: user.addressId
        }
      })
      let addy;
      if (address.suite) {
        addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

      } else {
        addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

      }
      if (updateQuote.state == 'Owner Declined') {

        await lastValueFrom(
          this.calendarClient.emit('owner declined copy', { "email": ownerinfo.at(0).user.email, "name": user.name, location: addy, "quote": quote })
        )

        await lastValueFrom(
          this.calendarClient.emit('owner declined', { "email": user.email, "name": user.name, "quote": quote })
        )

      } else if (updateQuote.state == 'Client Declined') {

        await lastValueFrom(
          this.calendarClient.emit('client declined copy', { "email": ownerinfo.at(0).user.email, "name": user.name, location: addy, "quote": quote })
        )

        await lastValueFrom(
          this.calendarClient.emit('client declined', { "email": user.email, "name": user.name, "quote": quote })
        )

      }
      //send email to owner and to client 

    }
    return 'Success'
  }

  getRepeat(type) {
    var x = 0;
    switch (type) {
      case 'Weekly':
        x = 7;
        break;
      case 'BiWeekly':
        x = 14;
        break;
      case 'TriWeekly':
        x = 21;
        break;
      case 'Monthly':
        x = 28;
        break;
      case 'Initial/Once':
        x = 0
        break;

    }
    console.log(x);
    console.log(type);
    return x;
  }

  async setUpDatesClient(calendarDay: CreateCalendarDayDto, type: String) {



    let start = new Date(calendarDay.date);
    var repeat = this.getRepeat(type);
    const dayOfWeek = start.getDay();
    var estimateSlots = await this.getOwnerPreferences();
    const index1 = estimateSlots.findIndex((emp) => emp.day == start.getDay());
    const baseDayTimeSlots = estimateSlots.at(index1)['time_slots'];
    baseDayTimeSlots.findIndex((e) => e == calendarDay.appointment_slots.at(0).time);

    if (index1 != -1) {
      //gets us the current days appointmentslots 
      //and updates it siunguilar tpo this appt case
      baseDayTimeSlots.splice(index1, 1);
    }
    // :white_check_mark: Exclude start date
    const end = new Date(calendarDay.date);
    end.setDate(start.getDate() + 360);

    var dates = [];
    var counter = 0;
    var automated = false;
    if (repeat == 0) {
      console.log("wtf");
      const appointmentslot = await this.prisma.calendarDay.findFirst({
        where: {
          date: new Date(start)
        }, include: {
          appointment_slots: true,

        }
      });
      //date has slots taken up
      if (appointmentslot) {
        //update with new slots available
        await this.prisma.calendarDay.update({
          where: { id: appointmentslot.id },
          data: {
            slots_available: calendarDay.daySlotsAvailable
          }
        });

        //add new appointment slot to calendar day 
        let appt = await this.prisma.appointment_slots.create({
          data: {
            //DATE IS THE OINE IN WHILE LOOOP CHNAGING
            date: start,
            //TIME 
            time: calendarDay.appointment_slots.at(0).time,
            //TYPE
            type: calendarDay.appointment_slots.at(0).type,
            clientId: calendarDay.appointment_slots.at(0).clientId,
            calendarDayId: appointmentslot.id
          }, include: {
            client: true,

          }
        })
        const userinfo = await this.prisma.user.findFirst({
          where: {
            id: appt.client.userId
          }
        })
        dates.push({ date: appt.date, time: calendarDay.appointment_slots.at(0).time })
      } else {
        //add calendar day as it was not found
        const createEstimate = await this.prisma.calendarDay.create({
          data: {
            date: new Date(calendarDay.date),
            slots_available: calendarDay.daySlotsAvailable,
          }
        })
        // add appointment meant to calendar day 
        const appt = await this.prisma.appointment_slots.create(
          {
            data: {
              date: new Date(createEstimate.date),
              time: calendarDay.appointment_slots.at(0).time,
              type: calendarDay.appointment_slots.at(0).type,
              clientId: calendarDay.appointment_slots.at(0).clientId,
              calendarDayId: createEstimate.id
            },
            include: {
              client: true,

            }

          }
        )


        //send email to let user know about confirmed estimate 
        //allow for cancellation through a link by providing delete on it 
        dates.push({ date: appt.date, time: calendarDay.appointment_slots.at(0).time })


      }
    } else {
      while (start < end) {
        if (counter == repeat) {
          counter = 0
        }
        //incorporate excluded
        if (start.getDay() == dayOfWeek && counter == 0) {

          const appointmentslot = await this.prisma.calendarDay.findFirst({
            where: {
              date: new Date(start)
            }, include: {
              appointment_slots: true,

            }
          });
          //date has slots taken up

          if (appointmentslot) {
            //update with new slots available
            var automatedTimeSlot = '';
            var index = appointmentslot.slots_available.findIndex((e) => e == calendarDay.appointment_slots.at(0).time)

            //we found it
            if (index >= 0) {
              //gets us the current days appointmentslots 
              //and updates it siunguilar tpo this appt case
              appointmentslot.slots_available.splice(index, 1);
              await this.prisma.calendarDay.update({
                where: { id: appointmentslot.id },
                data: {
                  slots_available: appointmentslot.slots_available
                }
              });
              //create day with that time slot
              let appt = await this.prisma.appointment_slots.create({
                data: {
                  //DATE IS THE OINE IN WHILE LOOOP CHNAGING
                  date: start,
                  //TIME 
                  time: calendarDay.appointment_slots.at(0).time,
                  //TYPE
                  type: calendarDay.appointment_slots.at(0).type,
                  clientId: calendarDay.appointment_slots.at(0).clientId,
                  calendarDayId: appointmentslot.id
                }, include: {
                  client: true,

                }
              })

              dates.push({ date: appt.date, time: calendarDay.appointment_slots.at(0).time })
            } else {
              //did not find it automatye time
              automated = true;

              appointmentslot.slots_available.push(calendarDay.appointment_slots.at(0).time);

              appointmentslot.slots_available.sort(function (a, b) {
                return new Date('1970/01/01 ' + a).valueOf() - new Date('1970/01/01 ' + b).valueOf();
              });

              var inuse = appointmentslot.slots_available.findIndex((e) => e == calendarDay.appointment_slots.at(0).time)

              if (inuse != appointmentslot.slots_available.length - 1) {
                console.log("not the end")
                automatedTimeSlot = appointmentslot.slots_available[inuse + 1];
                appointmentslot.slots_available.splice(inuse, 1);
                appointmentslot.slots_available.splice(appointmentslot.slots_available.findIndex((e) => e == automatedTimeSlot), 1);

              } else {
                console.log("the end")
                automatedTimeSlot = appointmentslot.slots_available[inuse - 1];
                appointmentslot.slots_available.splice(inuse, 1);
                appointmentslot.slots_available.splice(appointmentslot.slots_available.findIndex((e) => e == automatedTimeSlot), 1);
              }
              console.log("after" + appointmentslot.slots_available);
              console.log(automatedTimeSlot + "time");
              await this.prisma.calendarDay.update({
                where: { id: appointmentslot.id },
                data: {
                  slots_available: appointmentslot.slots_available
                }
              });
              //create day with that time slot
              let appt = await this.prisma.appointment_slots.create({
                data: {
                  //DATE IS THE OINE IN WHILE LOOOP CHNAGING
                  date: start,
                  //TIME 
                  time: automatedTimeSlot,
                  //TYPE
                  type: calendarDay.appointment_slots.at(0).type,
                  clientId: calendarDay.appointment_slots.at(0).clientId,
                  calendarDayId: appointmentslot.id
                }, include: {
                  client: true,

                }
              })
              dates.push({ date: appt.date, time: automatedTimeSlot })
            }



          } else {
            //add calendar day as it was not found

            const createEstimate = await this.prisma.calendarDay.create({
              data: {
                date: start,
                slots_available: baseDayTimeSlots,
              }
            })
            // add appointment meant to calendar day 
            const appt = await this.prisma.appointment_slots.create(
              {
                data: {
                  date: start,
                  time: calendarDay.appointment_slots.at(0).time,
                  type: calendarDay.appointment_slots.at(0).type,
                  clientId: calendarDay.appointment_slots.at(0).clientId,
                  calendarDayId: createEstimate.id
                },
                include: {
                  client: true,

                }

              }
            )


            //send email to let user know about confirmed estimate 
            //allow for cancellation through a link by providing delete on it 
            dates.push({ date: appt.date, time: calendarDay.appointment_slots.at(0).time })


          }
        }

        counter++;
        start.setDate(start.getDate() + 1);
      }
    }
    const userinfo = await this.prisma.user.findFirst({
      where: {
        client: { id: calendarDay.appointment_slots.at(0).clientId }
      }, include: {
        client: true,
        address: true
      }
    })
    const address = userinfo.address;
    let addy;
    if (address.suite) {
      addy = address.street + ` Apt #${address.suite} ` + address.city + ', ' + address.state + ' ' + address.zip;

    } else {
      addy = address.street + ' ' + address.city + ', ' + address.state + ' ' + address.zip;

    }
    const quote = await this.prisma.quote.findFirst({
      where: {
        clientId: userinfo.client.id
      }
    })
    var price = '';
    await this.prisma.quote.update({
      where: {
        id: quote.id
      }, data: {
        state: "Completed",

      }
    })
    const client = await this.prisma.owner.findMany({
      include: {
        user: true
      }
    });
    if (quote.state == "Owner Accepted Offered") {
      price = quote.offerClient;
      await this.prisma.client.update({
        where: { id: userinfo.client.id }, data: {
          amt_due: price
        }
      });
      this.calendarClient.emit('client booked', { "name": userinfo.name, email: userinfo.email, "type": type, dates: dates, automated: automated, price: price })
      this.calendarClient.emit('new client for owner', { "name": userinfo.name, email: client.at(0).user.email, "type": type, dates: dates, automated: automated, price: price, location: addy })

    }
    if (quote.state == "Owner Counter Offered") {
      price = quote.offerOwner;
      await this.prisma.client.update({
        where: { id: userinfo.client.id }, data: {
          amt_due: price
        }
      });
      this.calendarClient.emit('client booked', { "name": userinfo.name, email: userinfo.email, "type": type, dates: dates, automated: automated, price: price })
      this.calendarClient.emit('new client for owner', { "name": userinfo.name, email: client.at(0).user.email, "type": type, dates: dates, automated: automated, price: price, location: addy })

    }

    if (quote.state == "Owner Responded") {


      price = quote[`${type.toLowerCase()}`];
      await this.prisma.client.update({
        where: { id: userinfo.client.id }, data: {
          amt_due: price
        }
      });
      this.calendarClient.emit('client booked', { "name": userinfo.name, email: userinfo.email, "type": type, dates: dates, automated: automated, price: price })
      this.calendarClient.emit('new client for owner', { "name": userinfo.name, email: client.at(0).user.email, "type": type, dates: dates, automated: automated, price: price, location: addy })

    }

    return "Success";
  }

  async getOwnerAppointments() {
    const day = new Date();
    const calendarDays = await this.prisma.calendarDay.findMany({
      where: {
        date: {
          gte: new Date(day.getFullYear(), day.getMonth(), day.getDate() + 1)
        }
      }, include: {
        appointment_slots: true
      }
    });
    const all_slots = [];
    for (let index = 0; index < calendarDays.length; index++) {
      const day = calendarDays[index];
      if (day.appointment_slots.length > 0) {
        const appointment_slots = day.appointment_slots;
        const time_slots = [];
        for (let index = 0; index < appointment_slots.length; index++) {
          const appointment = appointment_slots[index];
          const user = await this.prisma.user.findFirst(
            {
              where: {
                client: {
                  id: appointment.clientId
                }
              }
            }
          )
          const timeslot = { "name": user.name, "time": appointment.time, "id": appointment.id }

          time_slots.push(timeslot);


        }
        all_slots.push({ date: new Date(day.date), time_slots: time_slots })

      }
    }
    return all_slots;
  }
  async getClient(id) {
    const userinfo = await this.prisma.user.findFirst({
      where: {
        client: { id: id }
      }, include: {
        client: true,
        address: true
      }
    })


    return { name: userinfo.name, address: userinfo.address, email: userinfo.email }
  }
}