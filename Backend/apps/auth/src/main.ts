import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { AuthModule } from './auth.module';

async function bootstrap() {
  const app = await NestFactory.create(AuthModule);
  const config = app.get<ConfigService>(ConfigService);
  const port = config.get<number>('port');
  await app.listen(port);
}
bootstrap();
