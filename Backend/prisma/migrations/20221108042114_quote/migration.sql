/*
  Warnings:

  - Added the required column `state` to the `Quote` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Quote" ADD COLUMN     "state" TEXT NOT NULL;
