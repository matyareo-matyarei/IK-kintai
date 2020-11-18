class WorkPlace < ActiveHash::Base
  self.data = [
    { id: 1, name: '勤務場所を選択してください' },
    { id: 2, name: '本部' },
    { id: 3, name: '千束通り' },
    { id: 4, name: '日暮里' },
    { id: 5, name: '浅草' },
    { id: 6, name: '社内研修' },
    { id: 7, name: '外出勤務' }
  ]
end
