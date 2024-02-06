import {
  BaseEntity,
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm'
import { Field, ID, InputType, ObjectType } from 'type-graphql'
import { Category } from './Category'

@Entity()
@ObjectType()
export class Picture extends BaseEntity {
  @PrimaryGeneratedColumn()
  @Field(() => ID)
  id: number

  @Column()
  @Field()
  filename: string

  @Column()
  @Field()
  urlHD: string

  @Column({ nullable: true })
  @Field({ nullable: true })
  urlMiniature: string

  @Column()
  @Field()
  createdBy: string

  @Column({ nullable: true })
  @Field()
  updatedBy: string

  @CreateDateColumn({ type: 'timestamp with time zone' })
  @Field()
  createdAt: Date

  @UpdateDateColumn({ type: 'timestamp with time zone', nullable: true })
  @Field({ nullable: true })
  updatedAt?: Date

  @OneToOne(() => Category, (category) => category.picture)
  category: Category
}

@InputType()
export class PictureCreateInput {
  @Field()
  filename: string
}
