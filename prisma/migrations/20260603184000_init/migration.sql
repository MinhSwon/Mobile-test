-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'RESCUE_LEADER', 'RESCUE_MEMBER', 'CITIZEN');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'BLOCKED');

-- CreateEnum
CREATE TYPE "TeamStatus" AS ENUM ('AVAILABLE', 'BUSY', 'OFFLINE');

-- CreateEnum
CREATE TYPE "RescueRequestStatus" AS ENUM ('PENDING', 'ASSIGNED', 'ACCEPTED', 'MOVING', 'NEAR_VICTIM', 'ARRIVED_CONFIRMED', 'RESCUING', 'RESCUED', 'TRANSFERRED_SAFEZONE', 'UNREACHABLE', 'NEED_SUPPORT', 'CANCELLED');

-- CreateEnum
CREATE TYPE "AlertLevel" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'EMERGENCY');

-- CreateEnum
CREATE TYPE "AlertStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'ACTIVE', 'EXPIRED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "SmsStatus" AS ENUM ('PENDING', 'SENT', 'FAILED');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "phone" TEXT,
    "email" TEXT,
    "password_hash" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'CITIZEN',
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',
    "avatar" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rescue_teams" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "leader_id" TEXT,
    "leader_name" TEXT,
    "status" "TeamStatus" NOT NULL DEFAULT 'AVAILABLE',
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "member_count" INTEGER NOT NULL DEFAULT 0,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rescue_teams_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rescue_requests" (
    "id" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "phone" TEXT,
    "address_detail" TEXT,
    "area_name" TEXT,
    "description" TEXT,
    "number_of_people" INTEGER NOT NULL DEFAULT 1,
    "emergency_level" "AlertLevel" NOT NULL DEFAULT 'HIGH',
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "status" "RescueRequestStatus" NOT NULL DEFAULT 'PENDING',
    "assigned_team_id" TEXT,
    "created_by_user_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "accepted_at" TIMESTAMP(3),
    "completed_at" TIMESTAMP(3),
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rescue_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "flood_alerts" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "level" "AlertLevel" NOT NULL DEFAULT 'MEDIUM',
    "status" "AlertStatus" NOT NULL DEFAULT 'DRAFT',
    "area_name" TEXT,
    "start_time" TIMESTAMP(3),
    "end_time" TIMESTAMP(3),
    "sms_sent" BOOLEAN NOT NULL DEFAULT false,
    "sms_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "flood_alerts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sms_logs" (
    "id" TEXT NOT NULL,
    "recipient" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "status" "SmsStatus" NOT NULL DEFAULT 'PENDING',
    "provider" TEXT,
    "error" TEXT,
    "sent_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" TEXT,
    "flood_alert_id" TEXT,

    CONSTRAINT "sms_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "rescue_requests_status_idx" ON "rescue_requests"("status");

-- CreateIndex
CREATE INDEX "rescue_requests_assigned_team_id_idx" ON "rescue_requests"("assigned_team_id");

-- CreateIndex
CREATE INDEX "flood_alerts_status_idx" ON "flood_alerts"("status");

-- CreateIndex
CREATE INDEX "flood_alerts_level_idx" ON "flood_alerts"("level");

-- CreateIndex
CREATE INDEX "sms_logs_status_idx" ON "sms_logs"("status");

-- CreateIndex
CREATE INDEX "sms_logs_phone_idx" ON "sms_logs"("phone");

-- AddForeignKey
ALTER TABLE "rescue_teams" ADD CONSTRAINT "rescue_teams_leader_id_fkey" FOREIGN KEY ("leader_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rescue_requests" ADD CONSTRAINT "rescue_requests_assigned_team_id_fkey" FOREIGN KEY ("assigned_team_id") REFERENCES "rescue_teams"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rescue_requests" ADD CONSTRAINT "rescue_requests_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sms_logs" ADD CONSTRAINT "sms_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sms_logs" ADD CONSTRAINT "sms_logs_flood_alert_id_fkey" FOREIGN KEY ("flood_alert_id") REFERENCES "flood_alerts"("id") ON DELETE SET NULL ON UPDATE CASCADE;
