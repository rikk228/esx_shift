$(function() {

    let url = 'https://esx_shift/';
    let started = false;

    function display(bool) {
        if (bool) {
            $("#root").show();
            $('#shiftResult').hide();
            return;
        }
        $("#root").hide();
    }

    display(false)

    window.addEventListener('message', function(event) {
        if (event.data.type === "ui") return display(event.data.status)
        if (event.data.type === "displayAllMineShift") displayAllMineShift(event.data.shifts)
        if (event.data.type === "showAllShifts") showAllShifts(event.data.shifts)
    });

    document.onkeyup = data => {
        if (data.key === "Escape") return $.post(`${url}exit`, JSON.stringify({}));
    };

    $('#startShift').click(e => {
        if (!started) $.post(`${url}startShift`)
        started = true;
    })

    $('#endShift').click(e => {
        if (started) $.post(`${url}endShift`)
        started = false;
    })

    $('#allMineShifts').click(e => {
        $.post(`${url}allMineShifts`)
    })

    $('#showAllShifts').click(e => {
        $.post(`${url}showAllShifts`)
    })

    $('#closeui').click(e => {
        return $.post(`${url}exit`, JSON.stringify({}));
    })

    $('#shiftResultClose').click(e => {
        $('#shiftResult').hide();
    })

    function displayAllMineShift(shift) {
        shift = JSON.parse(shift)
        let templateString = `<tr id="shift-iid"> <th>Start</th> <th>Stop</th> <th>Total Hrs</th> </tr>`;

        $('#shiftResultTable').empty();
        $('#shiftResult').show();

        if (!shift[0]) return $('#shiftResultTable').append('<p> No shifts Found! </p>');

        $('#shiftResultTable').append(`<tr id="main-row"> <th>Start</th> <th>Stop</th> <th>Total</th> <button id="shiftResultClose">Close</button> </tr>`);

        shift.forEach(el => {
            let initialDate = new Date(el.start)
            let endingDate = new Date(el.end)
            let diff = endingDate.getTime() - initialDate.getTime();
            const diffHrs = (diff / (1000 * 60 * 60));
            let str = templateString.replace('Start', el.start).replace('Stop', el.end).replace('Total', diffHrs).replace('iid', el.id)
            $('#shiftResultTable').append(str)
        });
    }

    function showAllShifts(shift) {
        shift = JSON.parse(shift)
        let templateString = `<tr id="shift-iid">  <th>name</th> <th>Start</th> <th>Stop</th> <th>Total Hrs</th> </tr>`;

        $('#shiftResultTable').empty();
        $('#shiftResult').show();

        if (!shift[0]) return $('#shiftResultTable').append('<p> No shifts Found or insufficient Permissions </p>');

        $('#shiftResultTable').append(`<tr id="main-row"> <th>Firstname Lastname</th> <th>Start</th> <th>Stop</th> <th>Total</th> <th>Actions</th> <button id="shiftResultClose">Close</button> </tr>`);


        shift.forEach(el => {
            let initialDate = new Date(el.start);
            let endingDate = new Date(el.end);
            let diff = endingDate.getTime() - initialDate.getTime();
            const diffHrs = (diff / (1000 * 60 * 60));
            let str = templateString.replace('Start', el.start).replace('Stop', el.end).replace('Total', diffHrs).replace('iid', el.id).replace('name', el.fullname)
            $('#shiftResultTable').append(str);
            let btn = document.createElement('button');
            btn.textContent = 'Delete';
            btn.id = 'deleteShift';
            btn.addEventListener('click', deleteShift);
            let th = document.createElement('th');
            th.appendChild(btn);
            $(`#shift-${el.id}`).append(th);
        });
    }

    function deleteShift(e) {
        let id = e.target.parentNode.parentNode.id;
        $(`#${id}`).empty();
        let rowId = id.split('-')[1];
        $.post(`${url}deleteShift`, JSON.stringify({ id: rowId }));
    }

})