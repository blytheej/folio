class Career < ActiveRecord::Base 
  acts_as_paranoid

  self.table_name = :careers

  belongs_to :user, class_name: 'User'

  validates :name, presence: { message: '을 입력하세요' }
  validates :start_date, presence: { message: '을 지정하세요' }
  validate :validate_end_date

  private

  # end_date 값이 start_date 값보다 이후인지 확인한다
  def validate_end_date
    return if end_date.blank?
    return if start_date <= end_date

    errors.add :end_date, '종료일시는 시작일시 이후이어야 합니다'
  end
end
