# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110923094135) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "plz"
    t.string   "city"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_attributes", :force => true do |t|
    t.string   "logo"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "signature"
    t.string   "footer"
    t.string   "unitprice"
    t.boolean  "hidden"
  end

  create_table "customers", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "addresses_id"
    t.integer  "invoices_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "companyname"
    t.string   "email"
  end

  create_table "file_paths", :force => true do |t|
    t.string   "path"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_posses", :force => true do |t|
    t.string   "invoiceposnr"
    t.text     "description"
    t.float    "qty"
    t.float    "unitprice"
    t.float    "total"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "mwst"
  end

  create_table "invoices", :force => true do |t|
    t.string   "invoicenr"
    t.integer  "customer_id"
    t.integer  "invoice_posses_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filepath"
  end

end
