import {
  BaseEntity,
  Column,
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'
import { Field, ID, Int, ObjectType } from 'type-graphql'
import { Picture } from './Picture.entity'
import { ProductReference } from './ProductReference.entity'

@Entity()
@ObjectType()
export class PictureProduct extends BaseEntity {
  @PrimaryGeneratedColumn()
  @Field(() => ID)
  id!: number

  @Column()
  @Field(() => Int)
  index!: number

  @ManyToOne(() => Picture, (picture) => picture.pictureProduct)
  picture!: Picture

  @ManyToOne(() => ProductReference, (picture) => picture.pictureProduct)
  productReference!: ProductReference
}
