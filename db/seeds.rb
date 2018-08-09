# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
careers = Career.create([
  {
    description: 'Informática',
  },
  {
    description: 'Civil',
  },
  {
    description: 'Electro',
  }
])

people = Person.create([
  {
    names: 'Martín Tamay',
    email: 'martin.tamay@fiuni.edu.py',
    password: 'humberto1',
    ci: '4.315.943',
    session_token: nil
  },
  {
    names: 'Deysi Santa Cruz',
    email: 'deysi.santa.cruz@fiuni.edu.py',
    password: 'deysi1',
    ci: '4.542.235',
    session_token: nil
  },
  {
    names: 'Administrador 1',
    email: 'administrador@fiuni.edu.py',
    password: 'administrador',
    ci: '2.578.452',
    session_token: nil
  },
  {
    names: 'Profesor 1',
    email: 'profesor@fiuni.edu.py',
    password: 'profesor',
    ci: '2.477.452',
    session_token: nil
  },
  {
    names: 'Profesor 2',
    email: 'profesor2@fiuni.edu.py',
    password: 'profesor2',
    ci: '1.524.598',
    session_token: nil
  }
])

administrators = Administrator.create([
  {
    person: people[2]
  }
])

professors = Professor.create([
  {
    person: people[3]
  },
  {
    person: people[4]
  }
])

students = Student.create([
  {
    entry_year: 2014,
    career: careers[0],
    person: people[0],
  },
  {
    entry_year: 2013,
    career: careers[0],
    person: people[1],
  }
])

subjects = Subject.create([
  {
    name: "Física 1",
    semester: 1,
    professor: professors[0],
    career: careers[0]
  },{
    name: "Física 2",
    semester: 1,
    professor: professors[0],
    career: careers[0]
  },{
    name: "Física 3",
    semester: 1,
    professor: professors[0],
    career: careers[0]
  },{
    name: "Análisis 1",
    semester: 1,
    professor: professors[1],
    career: careers[0]
  },{
    name: "Análisis 2",
    semester: 1,
    professor: professors[1],
    career: careers[0]
  },{
    name: "Análisis 3",
    semester: 1,
    professor: professors[1],
    career: careers[0]
  }
])

takens = Taken.create([
  #martin
  {
    inscription_date: "2014-07-29",
    finished: 1,
    finish_date: "2018-12-23",
    student: students[0],
    subject: subjects[0]
  },
  {
    inscription_date: "2014-07-29",
    finished: 0,
    finish_date: "2018-12-20",
    student: students[0],
    subject: subjects[3]
  },
  {
    inscription_date: "2015-02-27",
    finished: 0,
    finish_date: nil,
    student: students[0],
    subject: subjects[1]
  },
  {
    inscription_date: "2015-02-27",
    finished: 0,
    finish_date: nil,
    student: students[0],
    subject: subjects[4]
  },
  #deysi
  {
    inscription_date: "2013-07-26",
    finished: 0,
    finish_date: "2013-12-15",
    student: students[1],
    subject: subjects[0]
  },
  {
    inscription_date: "2013-07-26",
    finished: 0,
    finish_date: "2013-12-20",
    student: students[1],
    subject: subjects[3]
  },
  {
    inscription_date: "2014-02-27",
    finished: 0,
    finish_date: nil,
    student: students[0],
    subject: subjects[1]
  },
  {
    inscription_date: "2014-02-27",
    finished: 0,
    finish_date: nil,
    student: students[0],
    subject: subjects[4]
  },
  {
    inscription_date: "2018-02-23",
    finished: 0,
    finish_date: nil,
    student: students[0],
    subject: subjects[1]
  },
  {
    inscription_date: "2018-02-23",
    finished: 0,
    finish_date: nil,
    student: students[1],
    subject: subjects[1]
  },
  {
    inscription_date: "2018-02-24",
    finished: 0,
    finish_date: nil,
    student: students[0],
    subject: subjects[2]
  },
  {
    inscription_date: "2018-02-24",
    finished: 0,
    finish_date: nil,
    student: students[1],
    subject: subjects[2]
  }
])
examinations = Examination.create([
  #pp
  {
    examination_date: "2014-12-01",
    examination_type: "PP",
    subject: takens[0].subject
  },
  {
    examination_date: "2014-12-01",
    examination_type: "PP",
    subject: takens[1].subject
  },
  {
    examination_date: "2013-12-01",
    examination_type: "PP",
    subject: takens[4].subject
  },
  {
    examination_date: "2013-12-01",
    examination_type: "PP",
    subject: takens[5].subject
  },
  #finales
  {
    examination_date: "2014-12-23",
    examination_type: "Final",
    subject: takens[0].subject
  },
  {
    examination_date: "2014-12-20",
    examination_type: "Final",
    subject: takens[1].subject
  },
  {
    examination_date: "2013-12-15",
    examination_type: "Final",
    subject: takens[4].subject
  },
  {
    examination_date: "2013-12-20",
    examination_type: "Final",
    subject: takens[5].subject
  }
])
notes = Note.create([
  #pp
  {
    score: "4",
    approved: 1,
    percentage: 83,
    taken: takens[0],
    examination: examinations[0]
  },
  {
    score: "3",
    approved: 1,
    percentage: 73,
    taken: takens[1],
    examination: examinations[1]
  },
  {
    score: "5",
    approved: 1,
    percentage: 98,
    taken: takens[4],
    examination: examinations[2]
  },
  {
    score: "5",
    approved: 1,
    percentage: 100,
    taken: takens[5],
    examination: examinations[3]
  },
  #finales
  {
    score: "4",
    approved: 1,
    percentage: 83,
    taken: takens[0],
    examination: examinations[4]
  },
  {
    score: "3",
    approved: 1,
    percentage: 73,
    taken: takens[1],
    examination: examinations[5]
  },
  {
    score: "5",
    approved: 1,
    percentage: 98,
    taken: takens[4],
    examination: examinations[6]
  },
  {
    score: "5",
    approved: 1,
    percentage: 100,
    taken: takens[5],
    examination: examinations[7]
  }
])
