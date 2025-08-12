-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "UserRole" ADD VALUE 'STUDENT';
ALTER TYPE "UserRole" ADD VALUE 'PROFESSOR';

-- CreateTable
CREATE TABLE "Keyword" (
    "id" SERIAL NOT NULL,
    "value" TEXT NOT NULL,
    "ideaId" INTEGER NOT NULL,

    CONSTRAINT "Keyword_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Keyword" ADD CONSTRAINT "Keyword_ideaId_fkey" FOREIGN KEY ("ideaId") REFERENCES "Idea"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
