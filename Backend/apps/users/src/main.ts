import { NestFactory } from '@nestjs/core';

import { ConfigService } from '@nestjs/config';
import { Transport } from '@nestjs/microservices';
import { UsersModule } from './users/user/users.module';

async function bootstrap() {

  const app = await NestFactory.create(UsersModule);
  const config = app.get<ConfigService>(ConfigService);
  const port = config.get<number>('port');
  const internalPort = config.get<number>('internal_port');
  const host = config.get<string>('host');
  app.connectMicroservice({
    transport: Transport.TCP,
    options: {
      host: host,
      port: internalPort
    }
  });
  await app.startAllMicroservices();
  await app.listen(port);
}
bootstrap();
