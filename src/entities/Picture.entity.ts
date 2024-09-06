import {
  Column,
  Entity,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'
import { Field, ID, InputType, ObjectType } from 'type-graphql'
import { Category } from './Category.entity'
import { ProductReference } from './ProductReference.entity'
import { EntityWithDefault } from './EntityWithDefault'
import { User } from './User.entity'

@Entity()
@ObjectType()
export class Picture extends EntityWithDefault {
  @PrimaryGeneratedColumn()
  @Field(() => ID)
  id: number

  @Column()
  @Field()
  name: string

  @Field()
  get uri(): string {
    return `/api/images/${this.id}`
  }

  @Column({ nullable: true })
  @Field({ nullable: true })
  mimetype: string

  @Column({ nullable: true })
  //@Field({ nullable: true }) -- dont expose this path in graphql
  path: string

  @Column({ nullable: true })
  @Field({ nullable: true })
  urlHD: string

  @Column({ nullable: true })
  @Field({ nullable: true })
  urlMiniature: string

  @OneToOne(() => Category, (category) => category.picture, { nullable: true })
  @Field(() => Category, { nullable: true })
  category: Category

  @OneToOne(() => User, (user) => user.avatar, { nullable: true })
  @Field(() => User, { nullable: true })
  user: User

  @ManyToOne(
    () => ProductReference,
    (productReference) => productReference.pictures,
    { nullable: true }
  )
  @Field(() => ProductReference, { nullable: true })
  productReference: ProductReference
}

export type RelationType = 'category' | 'productReference' | 'user'

@InputType()
export class PictureCreateInput {
  @Field()
  name: string

  @Field()
  mimetype: string

  @Field()
  path: string

  @Field()
  urlHD: string

  @Field({ nullable: true })
  urlMiniature: string

  // @Field(() => ID)
  // referenceId: number

  // @Field()
  // type: RelationType
}

@InputType()
export class PictureUpdate {
  @Field({ nullable: true })
  name: string

  @Field({ nullable: true })
  urlHD: string

  @Field({ nullable: true })
  urlMiniature: string
}
