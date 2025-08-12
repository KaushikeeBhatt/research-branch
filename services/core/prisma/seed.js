import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const passwordHash = await bcrypt.hash('password123', 10);

  const user = await prisma.user.create({
    data: {
      name: 'Kaushikee',
      email: 'kaushikee@example.com',
      passwordHash,
      role: 'ADMIN',
      ideas: {
        create: {
          title: 'First Brilliant Idea',
          content: 'This is the content of the first brilliant idea.',
        },
      },
    },
    include: { ideas: true },
  });

  console.log('✅ Seeded user with idea:', user);
}

main()
  .catch((e) => {
    console.error('❌ Error seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
