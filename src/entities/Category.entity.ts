import 'reflect-metadata'
import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'
import { Field, ID, InputType, Int, ObjectType } from 'type-graphql'
import { Picture } from './Picture.entity'
import { ProductReference } from './ProductReference.entity'
import { EntityWithDefault } from './EntityWithDefault'

@Entity()
@ObjectType()
export class Category extends EntityWithDefault {
  @PrimaryGeneratedColumn()
  @Field(() => ID)
  id: number

  @Column({ length: 50, unique: true })
  @Field()
  name: string

  // index permet ordonner les catégories pour l'affichage
  @Column({ nullable: true })
  @Field(() => Int)
  index: number

  @Column({ default: true })
  @Field(() => Boolean, { nullable: true })
  display: boolean

  @ManyToOne(() => Category, (category) => category.childCategories, {
    nullable: true,
  })
  @Field(() => Category, { nullable: true })
  parentCategory?: Category

  @OneToMany(() => Category, (category) => category.parentCategory, {
    cascade: true,
  })
  @Field(() => [Category], { nullable: true })
  childCategories?: Category[]

  @OneToOne(() => Picture, { nullable: true })
  @JoinColumn({ name: 'pictureId', referencedColumnName: 'id' })
  @Field(() => Picture, { nullable: true })
  picture?: Picture

  @OneToMany(
    () => ProductReference,
    (productReference) => productReference.category,
    { cascade: true }
  )
  @Field(() => [ProductReference], { nullable: true })
  productReferences: ProductReference[]
}

@InputType()
export class CategoryCreateInput {
  @Field()
  name: string

  @Field(() => Int, { nullable: true })
  index: number

  @Field(() => Boolean, { nullable: true })
  display: boolean

  @Field(() => ID, { nullable: true })
  parentCategoryId: number
}

@InputType()
export class CategoryUpdateInput {
  @Field(() => ID)
  id: number

  @Field({ nullable: true })
  name?: string

  @Field(() => Int, { nullable: true })
  index?: number

  @Field(() => Boolean, { nullable: true })
  display?: boolean

  @Field(() => ID, { nullable: true })
  parentCategoryId: number
}
