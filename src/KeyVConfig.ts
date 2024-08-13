import Keyv from 'keyv'

export const keyV = new Keyv('redis://redis:6379', {
  namespace: 'renthub',
  serialize: JSON.stringify,
  deserialize: JSON.parse,
})
