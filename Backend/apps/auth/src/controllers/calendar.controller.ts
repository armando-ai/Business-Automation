import { Controller } from "@nestjs/common";
import { CalendarService } from "../services/calendar.service";

@Controller('calendar')
export class CalendarController {
  constructor(private readonly calendarService: CalendarService) {}
}