/*
  Warnings:

  - You are about to drop the column `from` on the `EstimateDayPreference` table. All the data in the column will be lost.
  - You are about to drop the column `to` on the `EstimateDayPreference` table. All the data in the column will be lost.
  - The `excluded_Days` column on the `Owner` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- CreateEnum
CREATE TYPE "appointment_type" AS ENUM ('client_estimate', 'client_appointment');

-- AlterTable
ALTER TABLE "EstimateDayPreference" DROP COLUMN "from",
DROP COLUMN "to",
ADD COLUMN     "timeSlots" TEXT[];

-- AlterTable
ALTER TABLE "Owner" DROP COLUMN "excluded_Days",
ADD COLUMN     "excluded_Days" TIMESTAMP(3)[];

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "role" TEXT NOT NULL DEFAULT '';

-- CreateTable
CREATE TABLE "CalendarDay" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "slots_available" TEXT[],

    CONSTRAINT "CalendarDay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "appointment_slots" (
    "date" TIMESTAMP(3) NOT NULL,
    "id" SERIAL NOT NULL,
    "time" TEXT NOT NULL,
    "type" "appointment_type" NOT NULL,
    "clientId" TEXT,
    "calendarDayId" TEXT,

    CONSTRAINT "appointment_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Client" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "amt_due" DOUBLE PRECISION,
    "amt_owed" DOUBLE PRECISION,

    CONSTRAINT "Client_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Quote" (
    "id" SERIAL NOT NULL,
    "clientId" TEXT NOT NULL,
    "weekly" INTEGER NOT NULL,
    "biweekly" INTEGER NOT NULL,
    "triWeekly" INTEGER NOT NULL,
    "monthly" INTEGER NOT NULL,
    "initial" INTEGER NOT NULL,
    "offerOwner" INTEGER NOT NULL,
    "offerClient" INTEGER NOT NULL,

    CONSTRAINT "Quote_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Client_userId_key" ON "Client"("userId");

-- AddForeignKey
ALTER TABLE "appointment_slots" ADD CONSTRAINT "appointment_slots_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "appointment_slots" ADD CONSTRAINT "appointment_slots_calendarDayId_fkey" FOREIGN KEY ("calendarDayId") REFERENCES "CalendarDay"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Quote" ADD CONSTRAINT "Quote_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
