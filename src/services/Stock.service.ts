import { Repository } from 'typeorm'
import { validate } from 'class-validator'
import { dataSource } from '../datasource'
import {
  Stock,
  StockCreateInput,
  StockUpdateInput,
} from '../entities/Stock.entity'

export class StockService {
  db: Repository<Stock>
  constructor() {
    this.db = dataSource.getRepository(Stock)
  }

  async findAll() {
    const stocks = this.db.find({
      relations: { productReference: { category: true } },
    })
    return stocks
  }

  async find(id: number) {
    const stock = await this.db.findOne({
      where: { id },
      relations: { productReference: { category: true } },
    })
    if (!stock) {
      throw new Error('Stock not found')
    }
    return stock
  }

  async create(stockInput: StockCreateInput) {
    const errors = await validate(stockInput)
    if (errors.length > 0) throw new Error('Validation failed!')

    const newStock = this.db.create(stockInput)
    if (!newStock) throw new Error('Stock not created')

    const { id } = await this.db.save(newStock)
    if (!id) throw new Error('Stock not saved')

    const stock = await this.find(id)
    if (!stock) {
      throw new Error(`Stock saved with id => < ${id} > but not found!`)
    }

    return stock
  }

  async update(data: StockUpdateInput) {
    const errors = await validate(data)
    if (errors.length > 0) {
      throw new Error('Validation failed!')
    }
    data.id = +data.id
    const stock = await this.db.findOne({
      where: { id: data.id },
      relations: { productReference: true },
    })
    if (!stock) throw new Error('Stock not found')

    // modification du parent :
    if (data.productReference !== undefined) {
      const productReferenceExist = await this.db.findOne({
        where: { id: data.productReference.id },
      })
      if (!productReferenceExist) {
        throw new Error('ProductReference not found')
      }
      Object.assign(stock, { productReference: productReferenceExist })
    }
    this.db.merge(stock, data)
    const updatedStock = await this.db.save(stock)
    return updatedStock
  }

  async delete(id: number) {
    const stock = await this.db.findOne({
      where: { id },
      relations: ['productReference'],
    })
    if (!stock) {
      throw new Error("Stock doesn't exist")
    }

    this.db.remove(stock)
    return true
  }
}
