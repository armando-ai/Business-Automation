/*
  Warnings:

  - You are about to drop the column `triWeekly` on the `Quote` table. All the data in the column will be lost.
  - Added the required column `triweekly` to the `Quote` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Quote" DROP COLUMN "triWeekly",
ADD COLUMN     "triweekly" TEXT NOT NULL;
