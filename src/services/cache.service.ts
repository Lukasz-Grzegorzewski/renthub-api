import { createClient } from 'redis'

export const redisClient = createClient({ url: 'redis://redis' })

redisClient.on('error', (error) => {
  console.error('Redis client error', error)
})

redisClient.on('connect', () => {
  // console.warn('Redis client connected')
})

export const redis = {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  get: async (key: string): Promise<any> => {
    const str = await redisClient.get(key)
    return str ? JSON.parse(str) : null
  },
  set: async (
    key: string,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    value: any,
    expInSeconds?: number
  ): Promise<void> => {
    await redisClient.set(key, JSON.stringify(value), {
      EX: expInSeconds,
    })
  },
  doConnect : async (): Promise<void> => {
    try {
      await redisClient.connect()
    } catch (error) {
      console.error('Redis client error', error)
    }
  },
  doDisconnect: async (): Promise<void> => {
    try {
      await redisClient.disconnect()
    } catch (error) {
      console.error('Redis client error', error)
    }
  }
}
