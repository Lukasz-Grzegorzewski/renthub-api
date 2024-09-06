import { config } from 'dotenv'
config()
//-----------------------------------------
//-----------------TYPE ORM----------------
//-----------------------------------------

import 'reflect-metadata'
import { dataSource } from './datasource'

//-----------------------------------------
//-----------------PICTURES----------------
//-----------------------------------------

//-----------------------------------------
//----------GRAPHQL / APOLLO SERVER--------
//-----------------------------------------

import { getSchema } from './schema'
import { ApolloServer } from '@apollo/server'
import { expressMiddleware } from '@apollo/server/express4'
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer'

//-----------------------------------------
//-----------------EXPRESS-----------------
//-----------------------------------------

import express, { Request, Response } from 'express'
import http from 'http'
import cors from 'cors'
import path from 'path'

import { initializeRoute } from './routes'

//-----------------------------------------
//-----------------APOLLO SERVER-----------
//-----------------------------------------

const app = express()
const corsOptions = {
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true,
  optionsSuccessStatus: 200,
  allowedHeaders: ['Content-Type', 'apollo-require-preflight'],
}
app.use(cors(corsOptions))
app.use(express.json({ limit: '50mb' }))
app.use('/api/images', express.static(path.join(__dirname, '../public/images')))

async function start() {
  const port = process.env.BACKEND_PORT || 5000

  const schema = await getSchema()

  const httpServer = http.createServer(app)
  const server = new ApolloServer({
    schema,
    plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
    introspection: true,
  })

  await dataSource.initialize()
  await server.start()

  app.use('/', (req: Request, res: Response, next) => {
    if (req.path === '/api/images' && req.method === 'POST') {
      return next()
    }
    // express.json({ limit: '50mb' }),
    expressMiddleware(server, {
      context: async (args) => {
        return {
          req: args.req,
          res: args.res,
        }
      },
    })(req, res, next)
  })

  initializeRoute(app)

  await new Promise<void>((resolve) =>
    httpServer.listen({ port: port }, resolve)
  )
  console.info(`🚀 Server ready at port ${port}  🚀`)
}

start()
