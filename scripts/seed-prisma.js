import 'dotenv/config';
import { prisma } from '../src/lib/prisma.js';
import {
  USERS,
  RESCUE_TEAMS,
  RESCUE_REQUESTS,
  FLOOD_WARNINGS,
  SMS_LOGS
} from '../src/data/mockData.js';

function toDate(value) {
  return value ? new Date(value) : null;
}

async function main() {
  await prisma.smsLog.deleteMany();
  await prisma.rescueRequest.deleteMany();
  await prisma.floodAlert.deleteMany();
  await prisma.rescueTeam.deleteMany();
  await prisma.user.deleteMany();

  await prisma.user.createMany({
    data: USERS.map(user => ({
      id: user.id,
      fullName: user.full_name,
      phone: user.phone,
      email: user.email,
      passwordHash: user.password_hash,
      role: user.role,
      status: user.status,
      avatar: user.avatar,
      createdAt: toDate(user.created_at) || new Date()
    })),
    skipDuplicates: true
  });

  await prisma.rescueTeam.createMany({
    data: RESCUE_TEAMS.map(team => ({
      id: team.id,
      name: team.team_name,
      phone: team.phone,
      leaderId: team.leader_id,
      leaderName: team.leader_name,
      status: team.status,
      latitude: team.latitude,
      longitude: team.longitude,
      memberCount: team.member_count || 0,
      notes: team.note || team.vehicle_type || null,
      createdAt: toDate(team.created_at) || new Date()
    })),
    skipDuplicates: true
  });

  await prisma.floodAlert.createMany({
    data: FLOOD_WARNINGS.map(alert => ({
      id: alert.id,
      title: alert.title,
      content: alert.content,
      level: alert.level,
      status: alert.status,
      areaName: alert.area_name,
      startTime: toDate(alert.start_time),
      endTime: toDate(alert.end_time),
      smsSent: Boolean(alert.sms_sent),
      smsCount: alert.sms_count || 0,
      createdAt: toDate(alert.created_at) || new Date()
    })),
    skipDuplicates: true
  });

  await prisma.rescueRequest.createMany({
    data: RESCUE_REQUESTS.map(request => ({
      id: request.id,
      fullName: request.full_name,
      phone: request.phone,
      addressDetail: request.address_detail,
      areaName: request.area_name,
      description: request.description,
      numberOfPeople: request.number_of_people || 1,
      emergencyLevel: request.emergency_level || 'HIGH',
      latitude: request.latitude,
      longitude: request.longitude,
      status: request.status,
      assignedTeamId: request.assigned_team_id,
      createdByUserId: request.citizen_id,
      createdAt: toDate(request.created_at) || new Date(),
      acceptedAt: toDate(request.accepted_at),
      completedAt: toDate(request.completed_at)
    })),
    skipDuplicates: true
  });

  await prisma.smsLog.createMany({
    data: SMS_LOGS.map(log => ({
      id: log.id,
      recipient: log.phone,
      phone: log.phone,
      message: log.message,
      status: log.status,
      provider: log.provider,
      sentAt: toDate(log.sent_at),
      floodAlertId: log.related_warning_id
    })),
    skipDuplicates: true
  });

  console.log('Prisma seed completed.');
}

main()
  .catch(error => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

