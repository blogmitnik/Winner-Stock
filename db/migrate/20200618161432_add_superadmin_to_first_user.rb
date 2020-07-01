class AddSuperadminToFirstUser < ActiveRecord::Migration[6.0]
  def change
  	User.create! do |u|
        u.email     = 'admin@winner-stock.com'
        u.password  = 'testPwd987'
        u.username 	= 'admin'
        u.name 		  = 'Winner Stock'
        u.slug      = 'winner-stock'
        u.superadmin_role = true
        u.supervisor_role = true
    end
  end
end
