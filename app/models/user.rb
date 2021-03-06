# frozen_string_literal: true

# 회원 모델
class User < ActiveRecord::Base
  has_secure_password
  # deleted_at 기반 소프트 딜리트 기능 이용
  acts_as_paranoid

  self.table_name = :users

  has_many :portfolios, class_name: 'Portfolio::Entity', foreign_key: :user_id, dependent: :destroy
  has_many :skills, class_name: 'Skill', foreign_key: :user_id, dependent: :destroy
  has_many :careers, class_name: 'Career', foreign_key: :user_id, dependent: :destroy
  has_many :educations, class_name: 'Education', foreign_key: :user_id, dependent: :destroy
  has_many :projects, class_name: 'Project', foreign_key: :user_id, dependent: :destroy

  GENDER = %w[남자 여자].freeze
  MAX_SIZE = {
    name: 100,
    mobile: 100,
    email: 500,
    address: 1000
  }.freeze

  validates :username,
            uniqueness: { case_sensitive: false, message: '값이 이미 존재합니다' },
            length: { in: 6..12, message: '는 6자리 이상 12자리 이하이어야 합니다' },
            format: {
              with: /\A[a-z]+[a-z0-9]{0,13}\z/,
              message: '은 영문 소문자로 시작하는 영문+숫자 조합이어야 합니다'
            }

  validates :gender, inclusion: { in: GENDER, message: '지정된 성별 분류를 따르지 않음' }, allow_nil: true
  validates :name, length: { maximum: MAX_SIZE[:name], message: "값이 #{MAX_SIZE[:name]}자를 초과함" }
  validates :mobile, length: { maximum: MAX_SIZE[:mobile], message: "값이 #{MAX_SIZE[:mobile]}자를 초과함" }
  validates :email, length: { maximum: MAX_SIZE[:email], message: "값이 #{MAX_SIZE[:email]}자를 초과함" }
  validates :address, length: { maximum: MAX_SIZE[:address], message: "값이 #{MAX_SIZE[:address]}자를 초과함" }

  validate :validate_password

  private

  def validate_password
    if password.nil?
      errors.add(:password, '를 입력해주세요') if password_digest.blank?
      return
    end

    errors.add :password, '는 8자리 이상이어야 합니다' if password.length < 8
    errors.add :password, '에 공백문자가 포함되지 않아야 합니다' if password.include?(' ')
  end
end