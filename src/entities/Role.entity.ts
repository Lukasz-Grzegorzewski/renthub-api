import {
  Column,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm'
import { Field, ID, InputType, ObjectType } from 'type-graphql'
import { Length, Matches } from 'class-validator'
import { User } from './User.entity'
import { EntityWithDefault } from './EntityWithDefault'

@Entity()
@ObjectType()
export class Role extends EntityWithDefault {
  @PrimaryGeneratedColumn()
  @Field(() => ID)
  id!: number

  @Column({ length: 50, unique: true})
  @Length(2, 50, { message: 'Entre 2 et 50 caractères' })
  @Matches(/^[a-zA-ZÀ-ÿ0-9-]+$/, {
    message:
      'Le nom du groupe Role peut contenir des lettres, des chiffres et des tirets',
  })
  @Field()
  name!: string

  @Column({
    type: 'enum',
    enum: ['ADMIN', 'USER'],
    default: 'USER',
  })
  @Field()
  right!: string

  @OneToMany(() => User, (user) => user.role)
  @Field(() => [User])
  user!: User
}

@InputType()
export class RoleCreateInput {
  @Field()
  name!: string

  @Field()
  right!: string
}

@InputType()
export class RoleUpdateInput {
  @Field({ nullable: true })
  name!: string

  @Field({ nullable: true })
  right!: string
}
