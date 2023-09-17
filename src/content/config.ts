import { defineCollection, z } from "astro:content";

const blog = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    description: z.string(),
    // Transform string to Date object
    pubDate: z
      .string()
      .or(z.date())
      .transform((val) => new Date(val)),
    updatedDate: z
      .string()
      .optional()
      .transform((str) => (str ? new Date(str) : undefined)),
    heroImage: z.string().optional(),
    devTo: z.string().optional(),
  }),
});

const portfolio = defineCollection({
  type: "data",
  schema: ({ image }) =>
    z.object({
      slug: z.string(),
      name: z.string(),
      image: image(),
      employer: z.string(),
      client: z.string(),
      website: z.string().optional(),
      short: z.string(),
      description: z.string(),
      tasks: z.string(),
      tags: z.array(z.string()),
    }),
});

const experiments = defineCollection({
  type: "data",
  schema: ({ image }) =>
    z.object({
      slug: z.string(),
      name: z.string(),
      image: image(),
      website: z.string().optional(),
      short: z.string(),
      description: z.string().optional(),
      tags: z.array(z.string()),
    }),
});

export const collections = { blog, portfolio, experiments };
