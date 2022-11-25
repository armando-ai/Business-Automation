import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PrismaModule, RmqModule } from '@app/common';
import { EurekaModule } from 'nestjs-eureka';
import { AuthModule } from '../../../../auth/src/auth.module';
import { HelperModule } from '@app/common/helper/helper.module';
import { BusinessController } from '../Owner/business.controller';
import { BusinessService } from '../Owner/business.service';
import { APP_GUARD } from '@nestjs/core';
import { AtGuard } from 'apps/auth/src/guards/at.guard';
import { UserMicroServiceController } from './user.microservice.controller';


@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: './apps/users/.env'
    }),
    AuthModule,
    PrismaModule,
    HelperModule,
    RmqModule.register({ name: 'USERS' }),
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
          name: 'users',
          port: 3000,
        },
      }),
      inject: [ConfigService]
    }),
  ],
  controllers: [
    UserMicroServiceController,
    UsersController,
    BusinessController
  ],
  providers: [
    UsersService, 
    BusinessService, 
    {
      provide: APP_GUARD,
      useClass: AtGuard
    }
  ],
  exports: [UsersService],
})
export class UsersModule { }
