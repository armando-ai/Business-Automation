import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PrismaModule, RmqModule } from '@app/common';
import { EurekaModule } from 'nestjs-eureka';
import { CalendarController } from './calendar.controller';
import { CalendarService } from './calendar.service';
import { ScheduleModule } from '@nestjs/schedule';


@Module({
  imports: [ConfigModule.forRoot({
    isGlobal: true,
    envFilePath: './apps/calendar/.env'
  }),
  ScheduleModule.forRoot(),
  PrismaModule,
  RmqModule.register({ name: 'CALENDAR' }),
  EurekaModule.forRootAsync({
    imports: [ConfigModule],
    useFactory: (config: ConfigService) => ({
      disable: false,
      disableDiscovery: false,
      eureka: {
        host: config.get<string>('e_host'),
        port: config.get<string>('e_port'),
        servicePath: '/eureka/apps',
        maxRetries: 10,
        requestRetryDelay: 10000,
      },
      service: {
        name: 'calendar',
        port: 4500,
      },
    }),
    inject: [ConfigService]
  })],
  controllers: [CalendarController],
  providers: [CalendarService],
  
})
export class CalendarModule {}
