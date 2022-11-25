/*
  Warnings:

  - You are about to drop the column `verify_Key` on the `User` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "User" DROP COLUMN "verify_Key",
ADD COLUMN     "verify_key" TEXT NOT NULL DEFAULT '',
ALTER COLUMN "verified" SET DEFAULT false,
ALTER COLUMN "updatePassword" SET DEFAULT false;
