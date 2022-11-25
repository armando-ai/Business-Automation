
import { Controller, Get } from '@nestjs/common';
import { Ctx, EventPattern, MessagePattern, Payload, RmqContext } from '@nestjs/microservices';
import { MailService, RmqService } from 'libs/common';


@Controller()
export class AppController {
  constructor(private readonly emailService: MailService, private readonly rmqService: RmqService) { }
  
  @MessagePattern('create')
  async handleUserCreate(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.sendUserConfirmationEmail(data.id,data.email,data.verify_key,data.name);
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('confirm estimate')
  async handleEstimateCreate(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.sendUserConfirmationEstimate(data.id,data.email,data.name,data.appt);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('owner estimate')
  async handlerEstimateOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.sendOwnerConfirmationEstimate(data.email,data.name,data.appt);
    
    this.rmqService.ack(context);
    return "Success";
  }

  @EventPattern('cancel estimate')
  async handleEstimateCancel(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.sendUserCancellationEstimate(data.email,data.name,data.appt);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('cancel owner estimate')
  async handlerEstimateOwnerCancel(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.sendOwnerCancellationEstimate(data.email,data.client_name,data.appt,data.appts);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('remind appt')
  async remindClient(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.sendClientReminder(data.email,data.name,data.appt);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('remind owner')
  async remindOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    console.log("i am the data", data.appts);
    this.emailService.sendOwnerReminder(data.email,data.name,data.appts);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('owner quote')
  async quoteOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
   
    this.emailService.sendOwnerQuote(data.email,data.name,data.quote,data.location);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('client quote')
  async quoteOfferClient(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {

    this.emailService.sendClientQuote(data.email,data.name,data.quote);
    
    this.rmqService.ack(context);
    return "Success";
  }
//owner offer
  @MessagePattern('owner offer')
  async quoteOfferOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
   
    this.emailService.sendOwnerQuoteOfferToOwner(data.email,data.name,data.quote,data.location);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @MessagePattern('owner to client quote offer')
  async quoteOwnerToClientOffer(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {

    this.emailService.sendOwnerQuoteOffer(data.email,data.name,data.quote);
    
    this.rmqService.ack(context);
    return "Success";
  }
  //client offer
  @EventPattern('client offer')
  async quoteClientToOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
   
    this.emailService.sendClientQuoteOffer(data.email,data.name,data.quote,data.location);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('client to owner quote')
  async quoteOffererClient(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {

    this.emailService.sendClientQuoteOfferToClient(data.email,data.name,data.quote);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('accepted client offer')
  async acceptquoteClientToOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
   
    this.emailService.sendAcceptedQuoteOwner(data.email,data.name,data.quote,data.location);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('accepted client copy')
  async acceptquoteOffererClient(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {

    this.emailService.AcceptedQuoteClient(data.email,data.name,data.quote);
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('client booked')
  async clientBooked(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.clientBooked(data.email,data.name,data.type,data.dates,data.automated,data.price);
    
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('new client for owner')
  async newClientToOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.newClient(data.email,data.name,data.type,data.dates,data.price,data.location);
    
    
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('owner declined')
  async DeclinedOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.ownerDecline(data.email,data.name,data.type,data.price,data.quote);
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('owner declined copy')
  async DeclinedClient(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.ownerDeclinedCopy(data.email,data.name,data.type,data.price,data.location,data.quote);
    this.rmqService.ack(context);
    return "Success";
  }

  @EventPattern('client declined')
  async DeclinedClient2(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.declinedClient(data.email,data.name,data.type,data.price,data.quote);
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('client declined copy')
  async DeclinedOwner2(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.declinedClientCopy(data.email,data.name,data.type,data.price,data.location,data.quote);
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('owner cancelled')
  async ownerCancel(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.ownerCancel(data.email,data.name,data.appt,data.available);
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('owner cancelled copy')
  async ownerCancelCopy(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.ownerCancelCopy(data.email,data.name,data.appt,data.appts);
    this.rmqService.ack(context);
    return "Success";
  }
  @EventPattern('service termination2')
  async terminateOwner(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.ownerTerminateCopy(data.email,data.name,data.addy);
    this.rmqService.ack(context);
    return "Success";
  }
   @EventPattern('service termination1')
  async terminateClient(@Payload() data: any, @Ctx() context: RmqContext): Promise<any> {
    this.emailService.clientTerminationCopy(data.email,data.name);
    this.rmqService.ack(context);
    return "Success";
  }
 
}

