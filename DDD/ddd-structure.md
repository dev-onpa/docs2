# DDD structure

Layer Architecture는 꾸준히 살펴 볼것.

## User Interface or Presentation Layer (ui / interface)
- Controller
- EventListener
- DTO (only for presentation purposes)
- FeignClient

## Application Layer (service)
- Domain Service
- 
- DTO (part of an API) - Not Domain

## Domain Layer

- Entity
- Repository (interface)
- Value Object (Address)


## Infrastructure
- RepositoryImpl (implement)
