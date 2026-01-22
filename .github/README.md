<center>

[![Vercel deployments](https://img.shields.io/github/deployments/tokcide/website/production?label=vercel&logo=vercel&style=for-the-badge)](https://kanishkk.vercel.app)
</center>

This is my personal project, I specifically made for learing more stuff.
It hosts my porfolio and some small projects that I didnt think needed a separate repo.
Enjoy!!

### Challenges

<details>

<summary> Deploying to Vercel

Posted In: [Astro Discord Help](https://discord.com/channels/830184174198718474/1463776611219406919)

</summary>

I am trying to deploy a Astrojs+Fastapi app on Vercel. I have spent and ungodly amount of time debugging this, I just need some help T^T. First I will be explaining my folder structure. I just cant be bothered to deal with a monorepo, so I have everything all inside one directory.
```tree
.
├── api
│   ├── main.py
├── src
│   ├── pages
│   │   ├── api/trpc/[trpc].ts
│   │   └── index.astro
│   ├── env.d.ts
│   ├── middleware.ts
├── astro.config.mjs
├── package.json
├── pnpm-lock.yaml
├── poetry.lock
├── pyproject.toml
├── uv.lock
└── vercel.json
```
- Routing all trpc endpoints to /api/trpc and similarly want to achieve the same for /api/python
- `api/main.py` this is the function I am trying to hit

This is an apt list of files- because writing the whole structure would take huge space - Please consider that there are necessary files to make the app run, and the only issue is of deployment to cloud. Below are the necessary files:

```py
# api/main.py
from fastapi import APIRouter, FastAPI

app = FastAPI()
mainRouter = APIRouter()

@mainRouter.get("/api/py")
def check():
    return "ok"


@mainRouter.get("/api/py/inventory")
async def get_package_inventory():
        return "inventory"

app.include_router(mainRouter)
```
```js
// @ts-check
import solidJs from "@astrojs/solid-js";
import vercel from "@astrojs/vercel";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "astro/config";

export default defineConfig({
  site: "<<--redacted-->>",
  output: "server",
  adapter: vercel({
    webAnalytics: { enabled: true },
    maxDuration: 10,
    excludeFiles: [],
  }),
  server: { port: 3000 },
  integrations: [solidJs({ devtools: true })],
  vite: {
    // @ts-expect-error
    plugins: [tailwindcss()],
  },
});
```
```json
{
  "framework": "astro",
  "outputDirectory": ".vercel/",
  "installCommand": "pnpm install",
  "buildCommand": "pnpm build",
  "devCommand": "pnpm dev",
  "rewrites": [
    { "source": "/api/py", "destination": "api/main.py" },
    { "source": "/api/py/(.*)", "destination": "api/main.py" }
  ]
}
```
I will write below my approaches to this problem:

1. Using the standard, adding `rewrites` property to `vercel.json` (as show above) - does not work. Some hours of AI debugging later (I am not smart enough to have reached this conclusion myself) I found out that Astro.js takes over the control of the routing from Vercel, and hence the rewrites property is just useless. Even adding a functions property as:  `"functions": {
    "api/main.py": {
      "runtime": "python"
    }
  }` does not work as vercel-cli says `Error: Function Runtimes must have a valid version, for example `now-php@1.0.0`.` It would be fine if I could find some documentation on the internet on how to do this for python. (Used github search as well - :) no luck)
2. Using redirects inside Astro itself - scrapping all the `rewrites` in `vercel.json` this finally works. But it does not pass the trailing paths to the python function. Say a redirects were : `redirects: {
     "/api/py": "/api/main.py",
     "/api/py/[...slug]": "/api/main.py",
   }` then the deployment does seem to render out (or return from API) `/api/py` -> `/api/main`. It is straight forward redirect where the URL in my browser changes. I don't know how good it will be at passing down request headers and body because I found a caveat before I could even try. All my requests say `/api/py/inventory` (after the `/py`) are being redirected to `/api/main`.
3. Running this down with AI has suggested me to further complicate things by using the `middleware.ts`, which I don't want to waste my time on. If any inputs on this - that if this is the right approach?

```diff
// middleware.ts for the sake of completion for all the above points
// git-diff shows the AI suggested chages (which I havent tried)
import { defineMiddleware } from "astro:middleware";
export const onRequest = defineMiddleware((context, next) => {
  const { locals } = context;
+ const url = new URL(context.request.url);

+ if (url.pathname.startsWith("/api/py")) {
+   const subPath = url.pathname.replace("/api/py", "");
+   const newUrl = new URL(url.origin);
+   newUrl.pathname = "/api/main";
+   newUrl.searchParams.set("path", subPath || "/");
+   return context.rewrite(newUrl.toString());
+ }
  locals.title = "Website";
  locals.welcomeTitle = () => "Welcome";
  return next();
});
```

Additional Comments:
- I would like a solutions without using `builds` and `routes` inside the `vercel.json` as they are deprecated.
- If not an answer please suggest me how I can improve this question, and where can I further get help on this topic.

</details>

### 🚀 Project Badges

![Vercel](https://img.shields.io/badge/vercel-%23000000.svg?style=for-the-badge&logo=vercel&logoColor=white)
![Dependabot](https://img.shields.io/badge/dependabot-025E8C?style=for-the-badge&logo=dependabot&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
[![PNPM](https://img.shields.io/badge/pnpm-F69220.svg?style=for-the-badge&logo=pnpm&logoColor=white)](https://pnpm.io/pnpm-cli)
[![Poetry](https://img.shields.io/badge/Poetry-60A5FA.svg?style=for-the-badge&logo=Poetry&logoColor=white)](https://python-poetry.org/docs/cli/)
[![Astro](https://img.shields.io/badge/astro-%232C2052.svg?style=for-the-badge&logo=astro&logoColor=white)](https://docs.astro.build/en/core-concepts/astro-syntax/)
[![SolidJS](https://img.shields.io/badge/SolidJS-2c4f7c?style=for-the-badge&logo=solid&logoColor=c8c9cb)](https://www.solidjs.com/docs/latest)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688.svg?style=for-the-badge&logo=FastAPI&logoColor=white)](https://fastapi.tiangolo.com/python-types/)
[![Pydantic](https://img.shields.io/badge/pydantic-%23E92063.svg?style=for-the-badge&logo=pydantic&logoColor=white)](https://docs.pydantic.dev/2.12/concepts/models/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/docs)
[![Trpc](https://img.shields.io/badge/tRPC-2596BE.svg?style=for-the-badge&logo=tRPC&logoColor=white)](https://trpc.io/docs)
[![Zod](https://img.shields.io/badge/Zod-3E67B1.svg?style=for-the-badge&logo=Zod&logoColor=white)](https://zod.dev/)

![Unocss](https://img.shields.io/badge/UnoCSS-333333.svg?style=for-the-badge&logo=UnoCSS&logoColor=white)
![Postcss](https://img.shields.io/badge/PostCSS-DD3A0A.svg?style=for-the-badge&logo=PostCSS&logoColor=white)
![Tailwind](https://img.shields.io/badge/Tailwind%20CSS-06B6D4.svg?style=for-the-badge&logo=Tailwind-CSS&logoColor=white)

[![simple-icons](https://img.shields.io/github/stars/simple-icons/simple-icons?label=simple-icons&style=for-the-badge)](https://github.com/simple-icons/simple-icons/blob/develop/slugs.md)

And here's [something](https://github.com/Ileriayo/markdown-badges) you'd love. [Bonus](https://home.aveek.io/GitHub-Profile-Badges/)
