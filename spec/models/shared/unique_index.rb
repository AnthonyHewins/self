# Workaround for the following not working:
# it {should validate_uniqueness_of(:user).scoped_to(:tag)}
# https://github.com/thoughtbot/shoulda-matchers/issues/814

RSpec.shared_examples "unique index" do |table, first, second|
  it "forces unique (#{first}_id, #{second}_id) pairs" do
    obj1, obj2 = create(first), create(second)
    create table, first => obj1, second => obj2
    expect{create table, first => obj1, second => obj2}
      .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Tag has already been taken')
  end
end
