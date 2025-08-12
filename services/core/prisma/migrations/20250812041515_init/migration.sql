/*
  Warnings:

  - The values [STUDENT,PROFESSOR] on the enum `UserRole` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `abstract` on the `Idea` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `Idea` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Idea` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `File` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Keyword` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `SimilarIdea` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_IdeaToKeyword` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_ideasOfInterest` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `content` to the `Idea` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "UserRole_new" AS ENUM ('USER', 'ADMIN');
ALTER TABLE "User" ALTER COLUMN "role" TYPE "UserRole_new" USING ("role"::text::"UserRole_new");
ALTER TYPE "UserRole" RENAME TO "UserRole_old";
ALTER TYPE "UserRole_new" RENAME TO "UserRole";
DROP TYPE "UserRole_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "File" DROP CONSTRAINT "File_authorId_fkey";

-- DropForeignKey
ALTER TABLE "SimilarIdea" DROP CONSTRAINT "SimilarIdea_ideaId_fkey";

-- DropForeignKey
ALTER TABLE "_IdeaToKeyword" DROP CONSTRAINT "_IdeaToKeyword_A_fkey";

-- DropForeignKey
ALTER TABLE "_IdeaToKeyword" DROP CONSTRAINT "_IdeaToKeyword_B_fkey";

-- DropForeignKey
ALTER TABLE "_ideasOfInterest" DROP CONSTRAINT "_ideasOfInterest_A_fkey";

-- DropForeignKey
ALTER TABLE "_ideasOfInterest" DROP CONSTRAINT "_ideasOfInterest_B_fkey";

-- AlterTable
ALTER TABLE "Idea" DROP COLUMN "abstract",
DROP COLUMN "createdAt",
DROP COLUMN "updatedAt",
ADD COLUMN     "content" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "createdAt",
DROP COLUMN "updatedAt",
ALTER COLUMN "role" SET DEFAULT 'USER';

-- DropTable
DROP TABLE "File";

-- DropTable
DROP TABLE "Keyword";

-- DropTable
DROP TABLE "SimilarIdea";

-- DropTable
DROP TABLE "_IdeaToKeyword";

-- DropTable
DROP TABLE "_ideasOfInterest";
