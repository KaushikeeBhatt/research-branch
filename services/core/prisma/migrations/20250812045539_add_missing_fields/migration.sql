/*
  Warnings:

  - You are about to drop the column `ideaId` on the `Keyword` table. All the data in the column will be lost.
  - You are about to drop the column `value` on the `Keyword` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[keyword]` on the table `Keyword` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `updatedAt` to the `Idea` table without a default value. This is not possible if the table is not empty.
  - Added the required column `keyword` to the `Keyword` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Keyword" DROP CONSTRAINT "Keyword_ideaId_fkey";

-- AlterTable
ALTER TABLE "Idea" ADD COLUMN     "abstract" TEXT,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "Keyword" DROP COLUMN "ideaId",
DROP COLUMN "value",
ADD COLUMN     "keyword" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "_IdeaToKeyword" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_UserInterests" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_IdeaToKeyword_AB_unique" ON "_IdeaToKeyword"("A", "B");

-- CreateIndex
CREATE INDEX "_IdeaToKeyword_B_index" ON "_IdeaToKeyword"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_UserInterests_AB_unique" ON "_UserInterests"("A", "B");

-- CreateIndex
CREATE INDEX "_UserInterests_B_index" ON "_UserInterests"("B");

-- CreateIndex
CREATE UNIQUE INDEX "Keyword_keyword_key" ON "Keyword"("keyword");

-- AddForeignKey
ALTER TABLE "_IdeaToKeyword" ADD CONSTRAINT "_IdeaToKeyword_A_fkey" FOREIGN KEY ("A") REFERENCES "Idea"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_IdeaToKeyword" ADD CONSTRAINT "_IdeaToKeyword_B_fkey" FOREIGN KEY ("B") REFERENCES "Keyword"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserInterests" ADD CONSTRAINT "_UserInterests_A_fkey" FOREIGN KEY ("A") REFERENCES "Idea"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserInterests" ADD CONSTRAINT "_UserInterests_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
