const now = () => {
  const button = document.querySelector("button"); //nowボタン情報(DOM)をbuttonにいれる
  button.addEventListener("click", (e) => { //nowボタンがクリックされたら
    const workDay = document.getElementById("attendance-work-days");
    const date_obj = new Date();// 現在時間が格納された、Dateオブジェクト作成
    const dayDate = date_obj.getFullYear() + "-" +
                  ("00" + (date_obj.getMonth() + 1)).slice(-2) + "-" +
                  ("00" + (date_obj.getDate())).slice(-2);
    workDay.value = dayDate; // 日付入力

    const workTime = document.getElementById("attendance-work-time");
    const timeDate = ("00" + (date_obj.getHours())).slice(-2) + ":" + 
                    ("00" + (date_obj.getMinutes())).slice(-2);
    workTime.value = timeDate;
    }
  );
};

window.addEventListener("turbolinks:load", now);
