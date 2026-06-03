# Huong dan dua du an len domain

Du an nay da duoc cau hinh de chay frontend React va backend Express tren cung mot domain.

## Chay thu tren may

```bash
npm install
npm run build
npm start
```

Mo:

```text
http://localhost:5000
http://localhost:5000/api/health
```

## Deploy len Render

1. Dua source code len GitHub.
2. Vao Render, tao `New Web Service`.
3. Chon repository cua du an.
4. Cau hinh:
   - Build Command: `npm install && npm run build`
   - Start Command: `npm start`
   - Environment: `Node`
5. Deploy xong, thu URL Render cap cho ban.

## Gan ten mien rieng

1. Vao Render service > Settings > Custom Domains.
2. Them domain, vi du `cuuho.example.com`.
3. Render se hien DNS record can them.
4. Vao noi quan ly DNS cua domain va them record do.
5. Doi DNS cap nhat va bat HTTPS tren Render.

## Bien moi truong nen cau hinh

```text
PORT=5000
CLIENT_ORIGINS=https://ten-mien-cua-ban.com
DATABASE_URL=postgresql://user:password@host:5432/flood_rescue
PGSSL=true
```

Ghi chu:

- `PORT` thuong duoc hosting tu gan, khong can dat tren Render.
- `CLIENT_ORIGINS` co the bo trong neu frontend va API chay cung domain.
- Khi co `DATABASE_URL`, Prisma se ket noi PostgreSQL va quan ly cac bang quan he.
- Neu khong co `DATABASE_URL`, backend se fallback ve `db.json`.
- `PGSSL=true` thuong can cho database tren hosting. Neu PostgreSQL chay local bang pgAdmin thi de `PGSSL=false`.

## Tao database bang pgAdmin

1. Mo pgAdmin va ket noi PostgreSQL server.
2. Tao file `.env` tu `.env.example`, sua mat khau PostgreSQL:

```text
DATABASE_URL=postgresql://postgres:mat_khau_cua_ban@localhost:5432/flood_rescue
PGSSL=false
```

3. Chay lenh Prisma setup:

```bash
npm run db:setup
```

Lenh nay se:

- Tao database `flood_rescue` neu chua co.
- Doc `prisma/schema.prisma`.
- Tao migration SQL cho cac bang `users`, `rescue_teams`, `rescue_requests`, `flood_alerts`, `sms_logs`.
- Chay migration vao PostgreSQL.
- Sinh Prisma Client cho backend.
- Seed du lieu mau vao cac bang Prisma.

4. Chay lai server:

```bash
npm run build
npm start
```

Trong pgAdmin, mo database `flood_rescue` de xem cac bang Prisma da tao.

## Quy mo 30-50 nguoi

Cau hinh PostgreSQL hien tai phu hop hon `db.json` cho demo/nhom nho 30-50 nguoi voi luu luong vua phai.

Neu dung that lau dai, nen nang cap tiep:

- Ma hoa mat khau bang bcrypt.
- Them session/JWT cho dang nhap.
- Them backup du lieu tu dong.
- Them monitoring/logging loi.
