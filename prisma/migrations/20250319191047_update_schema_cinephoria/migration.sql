/*
  Warnings:

  - You are about to drop the `Review` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ReviewPage` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ReviewPageAnalytics` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Tag` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `TagsOnReviews` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Review" DROP CONSTRAINT "Review_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Review" DROP CONSTRAINT "Review_pageId_fkey";

-- DropForeignKey
ALTER TABLE "ReviewPage" DROP CONSTRAINT "ReviewPage_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "ReviewPageAnalytics" DROP CONSTRAINT "ReviewPageAnalytics_pageId_fkey";

-- DropForeignKey
ALTER TABLE "Tag" DROP CONSTRAINT "Tag_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "TagsOnReviews" DROP CONSTRAINT "TagsOnReviews_reviewId_fkey";

-- DropForeignKey
ALTER TABLE "TagsOnReviews" DROP CONSTRAINT "TagsOnReviews_tagId_fkey";

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "birthday" TEXT,
ADD COLUMN     "movieId" TEXT;

-- AlterTable
ALTER TABLE "verificationtokens" ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "verificationtokens_pkey" PRIMARY KEY ("id");

-- DropTable
DROP TABLE "Review";

-- DropTable
DROP TABLE "ReviewPage";

-- DropTable
DROP TABLE "ReviewPageAnalytics";

-- DropTable
DROP TABLE "Tag";

-- DropTable
DROP TABLE "TagsOnReviews";

-- DropEnum
DROP TYPE "ReviewStatus";

-- CreateTable
CREATE TABLE "Movie" (
    "id" TEXT NOT NULL,
    "idx" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "poster" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "actors" TEXT[],
    "directors" TEXT[],
    "musicComposer" TEXT[],
    "synopsis" TEXT NOT NULL,
    "movieDate" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "ageLimit" INTEGER NOT NULL,
    "favorite" BOOLEAN NOT NULL,
    "duration" INTEGER NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Movie_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cinema" (
    "id" TEXT NOT NULL,
    "idx" SERIAL NOT NULL,
    "city" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cinema_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Hall" (
    "id" TEXT NOT NULL,
    "idx" SERIAL NOT NULL,
    "hallNumber" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL,
    "disabled_places" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Hall_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "City" (
    "id" TEXT NOT NULL,
    "idx" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "cp" INTEGER NOT NULL,
    "country" TEXT NOT NULL,
    "region" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "City_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CineSession" (
    "id" TEXT NOT NULL,
    "idx" SERIAL NOT NULL,
    "movieId" TEXT NOT NULL,
    "sessionStart" TIMESTAMP(3) NOT NULL,
    "sessionEnd" TIMESTAMP(3) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "cineId" TEXT NOT NULL,
    "hallId" TEXT NOT NULL,
    "note" INTEGER NOT NULL,
    "pricing" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CineSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reservation" (
    "id" TEXT NOT NULL,
    "idx" SERIAL NOT NULL,
    "userId" TEXT NOT NULL,
    "qr_code" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "movieId" TEXT NOT NULL,
    "cineId" TEXT NOT NULL,
    "cineSessionId" TEXT,
    "quantity" INTEGER NOT NULL,
    "disabled_paces" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reservation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CineSessionToCinema" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_CineSessionToCinema_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Movie_idx_key" ON "Movie"("idx");

-- CreateIndex
CREATE UNIQUE INDEX "Cinema_idx_key" ON "Cinema"("idx");

-- CreateIndex
CREATE UNIQUE INDEX "Hall_idx_key" ON "Hall"("idx");

-- CreateIndex
CREATE UNIQUE INDEX "City_idx_key" ON "City"("idx");

-- CreateIndex
CREATE UNIQUE INDEX "CineSession_idx_key" ON "CineSession"("idx");

-- CreateIndex
CREATE UNIQUE INDEX "Reservation_idx_key" ON "Reservation"("idx");

-- CreateIndex
CREATE INDEX "_CineSessionToCinema_B_index" ON "_CineSessionToCinema"("B");

-- AddForeignKey
ALTER TABLE "CineSession" ADD CONSTRAINT "CineSession_hallId_fkey" FOREIGN KEY ("hallId") REFERENCES "Hall"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reservation" ADD CONSTRAINT "Reservation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reservation" ADD CONSTRAINT "Reservation_cineId_fkey" FOREIGN KEY ("cineId") REFERENCES "Cinema"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reservation" ADD CONSTRAINT "Reservation_cineSessionId_fkey" FOREIGN KEY ("cineSessionId") REFERENCES "CineSession"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CineSessionToCinema" ADD CONSTRAINT "_CineSessionToCinema_A_fkey" FOREIGN KEY ("A") REFERENCES "CineSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CineSessionToCinema" ADD CONSTRAINT "_CineSessionToCinema_B_fkey" FOREIGN KEY ("B") REFERENCES "Cinema"("id") ON DELETE CASCADE ON UPDATE CASCADE;
