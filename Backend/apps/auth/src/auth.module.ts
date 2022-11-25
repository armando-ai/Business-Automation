import { CALENDAR_SERVICE, HelperModule, USERS_SERVICE } from '@app/common';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ConfigService } from '@nestjs/config/dist';
import { APP_GUARD } from '@nestjs/core';
import { ClientsModule } from '@nestjs/microservices';
import { Transport } from '@nestjs/microservices/enums';
import { AuthController } from './controllers/auth.controller';
import { UsersController } from './controllers/users.controller';
import { AtGuard } from './guards/at.guard';
import { LocalAuthGuard } from './guards/local.guard';
import { RtGuard } from './guards/rt.guard';
import { AuthService } from './services/auth.service';
import { UsersService } from './services/users.service';
import { AtStrategy } from './strategies/at.strategy';
import { LocalStrategy } from './strategies/local.strategy';
import { RtStrategy } from './strategies/rt.strategy';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { CalendarController } from './controllers/calendar.controller';
import { CalendarService } from './services/calendar.service';
import { EurekaModule } from 'nestjs-eureka';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: './apps/auth/.env'
    }),
    EurekaModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        disable: false,
        disableDiscovery: false,
        eureka: {
          host: config.get<string>('e_host'),
          port: config.get<number>('e_port'),
          servicePath: '/eureka/apps',
          maxRetries: 10,
          requestRetryDelay: 10000
        }, service: {
          name: 'auth',
          port: config.get<number>('port')
        }
      }),
      inject: [ConfigService]
    }),
    ClientsModule.registerAsync([
      {
        name: USERS_SERVICE,
        imports: [ConfigModule],
        useFactory: (config: ConfigService) => ({
          transport: Transport.TCP,
          options: {
            host: config.get<string>('users_host'),
            port: config.get<number>('users_port')
          }
        }),
        inject: [ConfigService]
      },
      {
        name: CALENDAR_SERVICE,
        imports: [ConfigModule],
        useFactory: (config: ConfigService) => ({
          transport: Transport.TCP,
          options: {
            host: config.get<string>('calendar_host'),
            port: config.get<number>('calendar_port')
          }
        }),
        inject: [ConfigService]
      }
    ]),
    HelperModule,
    JwtModule.register({}),
    PassportModule
  ],
  controllers: [
    AuthController,
    UsersController,
    CalendarController
  ],
  providers: [
    AuthService,
    UsersService,
    CalendarService,
    LocalStrategy,
    LocalAuthGuard,
    AtStrategy,
    AtGuard,
    RtStrategy,
    RtGuard,
    {
      provide: APP_GUARD,
      useClass: AtGuard
    }
  ],
  exports: [
    AtGuard,
    AtStrategy, 
    RtGuard,
    RtStrategy,
  ]
})
export class AuthModule { }