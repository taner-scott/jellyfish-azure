::ProductType.create_with(
  question_form_schema: ::QuestionFormSchema.new(
    schema: Jellyfish::Fog::Azure::DatabaseProductType.product_questions
  )
).find_or_create_by!(
  description: Jellyfish::Fog::Azure::DatabaseProductType.description,
  name: Jellyfish::Fog::Azure::DatabaseProductType.name,
)

::ProductType.create_with(
  question_form_schema: ::QuestionFormSchema.new(
    schema: Jellyfish::Fog::Azure::StorageProductType.product_questions
  )
).find_or_create_by!(
  description: Jellyfish::Fog::Azure::StorageProductType.description,
  name: Jellyfish::Fog::Azure::StorageProductType.name,
)

::ProductType.create_with(
  question_form_schema: ::QuestionFormSchema.new(
    schema: Jellyfish::Fog::Azure::InfrastructureProductType.product_questions
  )
).find_or_create_by!(
  description: Jellyfish::Fog::Azure::InfrastructureProductType.description,
  name: Jellyfish::Fog::Azure::InfrastructureProductType.name,
)
