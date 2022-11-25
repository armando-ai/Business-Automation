import { PartialType } from '@nestjs/mapped-types';
import { CreateCalendarDayDto, quote } from './createDay.dto';

export class UpdateCalendarDayDto extends PartialType(CreateCalendarDayDto) {
    id: string;
  }
  export class UpdateQuote extends PartialType(quote) {
    id: string;
   
  }