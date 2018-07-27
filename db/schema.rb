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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180727200021) do

  create_table "administrators", force: :cascade do |t|
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_administrators_on_person_id"
  end

  create_table "careers", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "examinations", force: :cascade do |t|
    t.string "examination_type"
    t.date "examination_date"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_examinations_on_subject_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "score"
    t.integer "approved"
    t.integer "percentage"
    t.integer "taken_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "opportunity"
    t.integer "checked"
    t.integer "examination_id"
    t.index ["examination_id"], name: "index_notes_on_examination_id"
    t.index ["taken_id"], name: "index_notes_on_taken_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "names"
    t.string "email"
    t.string "password"
    t.string "ci"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professors", force: :cascade do |t|
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_professors_on_person_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "entry_year"
    t.integer "career_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "android_session_token"
    t.index ["career_id"], name: "index_students_on_career_id"
    t.index ["person_id"], name: "index_students_on_person_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.integer "semester"
    t.integer "professor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "career_id"
    t.index ["career_id"], name: "index_subjects_on_career_id"
    t.index ["professor_id"], name: "index_subjects_on_professor_id"
  end

  create_table "takens", force: :cascade do |t|
    t.date "inscriptionDate"
    t.integer "finished"
    t.date "finish_date"
    t.integer "student_id"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_takens_on_student_id"
    t.index ["subject_id"], name: "index_takens_on_subject_id"
  end

end
