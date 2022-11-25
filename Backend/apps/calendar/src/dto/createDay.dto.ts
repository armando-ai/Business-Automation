import { CreateClientDto } from "@app/common/dto/users/create-user.dto"
import { appointment_type } from "@prisma/client"

export class CreateCalendarDayDto{
    date:Date
    appointment_slots?: appointment_slots[]
    daySlotsAvailable: string[]
}


export class appointment_slots{
    date:Date
    time:string
    type: appointment_type
    clientId: string
}     


export class day_span{
    from:Date
    to:Date
}

export class quote {
   
    clientId         :string
    weekly:string
    biweekly:string
    triweekly:string
    monthly:string 
    initial:string 
    offerOwner?:string
    offerClient?:string
    state?:string
    offerType?: any;
  }