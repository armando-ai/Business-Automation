import { Body, Controller, Delete, Get, Param, Post, UseGuards } from '@nestjs/common';
import { CalendarDay, Quote } from '@prisma/client';
import { CalendarService } from './calendar.service';
import { appointment_slots, CreateCalendarDayDto, day_span } from './dto/createDay.dto';
import { UpdateQuote } from './dto/updateDay.dto';

@Controller('calendar')
export class CalendarController {
  constructor(private readonly calendarService: CalendarService) { }

  @Post('dayspans')
  getHello(@Body() span: day_span) {
    return this.calendarService.getDatesInRange(span.from, span.to);
  }

  @Post('estimate')
  postEstimate(@Body() day: CreateCalendarDayDto) {
    return this.calendarService.createEstimate(day);
    // ->userservice prefernece ->['']
  }

  @Get('appointment/:id/:type')
  deleteAppointment(@Param('id') id, @Param('type') type) {
    return this.calendarService.deleteAppointmentSlot(parseInt(id), type);
  }
  @Get("getClientAppts/:id")
  getClientAppts(@Param('id') id) {
    return this.calendarService.getAppointments(id);
  }
  @Get('ownerschedule')
  getOwnerSchedule() {
    return this.calendarService.dailySchedule();
  }
  @Get('ownerestimates')
  getOwnerPendingEstimates() {
    return this.calendarService.pendingEstimates();
  }
  @Post('makequote')
  makeClientQuote(@Body() quote: Quote) {
    console.log(quote);
    return this.calendarService.createQuote(quote);
  }
  @Get('getclientquote/:id')
  getClientQuote(@Param('id') id) {

    return this.calendarService.getQuoteClient(id);
  }
  @Post('sendoffer/:id')
  sendClientOffer(@Param('id') id, @Body() quote: UpdateQuote) {

    return this.calendarService.updateQuote(id, quote);
  }
  @Post('owneracceptoffer/:id')
  owneracceptoffer(@Param('id') id, @Body() quote: UpdateQuote) {

    return this.calendarService.ownerAcepptQuote(id, quote);
  }
  @Post('newClient/:type')
  clientAccepted(@Body() day: CreateCalendarDayDto, @Param('type') type) {

    return this.calendarService.setUpDatesClient(day, type);

  }
  @Get('ownerAppointments')
  getAllAppointments(){
    return this.calendarService.getOwnerAppointments();
  }
  @Get('ownerPref')
  getOwnerPref(){
   return this.calendarService.getOwnerPreferences();
  }
  @Get('excluded')
  getOwnerExcluded(){
   return this.calendarService.getExcluded();
  }
  @Get('allClients')
  getAllClients(){
   return this.calendarService.getAllClients();
  }
  @Get('client/:id')
  getClient(@Param('id') id){
   return this.calendarService.getClient(id);
  }
  @Get('delclient/:id')
  deleteClient(@Param('id') id){
   return this.calendarService.deleteClient(id);
  }
}